#!/bin/bash

start_nats_server() {
    # Run nats-server and purge its logs
    nats-server --config /etc/nats/nats-server.conf > /dev/null 2>&1 &

    # Wait for nats-server to be ready
    timeout_seconds=10
    start_time=$(date +%s.%N)
    deadline_time=$(echo "$start_time + $timeout_seconds" | bc -l)
    while ! timeout 1 nats --user=sys --password=syspass server ping >/dev/null 2>&1; do
        sleep 0.2
        current_time=$(date +%s.%N)
        if (( $(echo "$current_time > $deadline_time" | bc -l) )); then
            echo "⏰ Nats server failed to start after ${timeout_seconds} seconds."
            exit 1
        fi
    done
}

stop_nats_server() {
    # kill nats-server
    kill -9 $(pgrep nats-server)

    # wait for nats-server to exit
    wait $(pgrep nats-server)
}

parse_args() {
    TIMEOUT=10
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --timeout)
                TIMEOUT="$2"
                shift 2
                ;;
            *)
                COMMAND_ARGS=("$@")
                break
                ;;
        esac
    done
}

read_command_from_stdin() {
    if [ ${#COMMAND_ARGS[@]} -eq 0 ] && [ ! -t 0 ]; then
        COMMAND=$(cat -)
        COMMAND_ARGS=($COMMAND)
    fi
}

preprocess_command() {
    if [ ${#COMMAND_ARGS[@]} -eq 0 ]; then
        echo "No command provided."
        exit 1
    fi
    if [ ${#COMMAND_ARGS[@]} -eq 1 ] && [[ "${COMMAND_ARGS[0]}" == *" "* ]]; then
        COMMAND_ARGS=(${COMMAND_ARGS[0]})
    fi
    COMMAND_STR="${COMMAND_ARGS[*]}"

    # Handle line continuations
    COMMAND_STR=$(echo "$COMMAND_STR" | sed 's/\\[[:space:]]/ /g')
    COMMAND_STR=$(echo "$COMMAND_STR" | sed 's/\\$//g')
}

add_auth_flags() {
    # Replace both && and ; with a single delimiter for splitting
    # IFS cannot handle multi-character sequences like &&, so we use sed to replace them
    SPLIT_CLEANED_COMMAND=$(echo "$COMMAND_STR" | sed 's/&&/|/g; s/;/|/g')

    IFS='|' read -ra SUBCOMMANDS <<< "$SPLIT_CLEANED_COMMAND"
    AUTH_COMMANDS=()
    for subcommand in "${SUBCOMMANDS[@]}"; do
        subcommand=$(echo "$subcommand" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if [[ -z "$subcommand" ]]; then
            continue
        fi
        if [[ "$subcommand" =~ ^nats ]]; then
            # Remove any existing auth flags
            subcommand=$(echo "$subcommand" | sed -E 's/--user(=[^ ]+| [^ ]+)? ?//g; s/--password(=[^ ]+| [^ ]+)? ?//g')

            # Add auth flags
            auth_subcommand=$(echo "$subcommand" | sed 's/^nats/& --user=ruser --password=T0pS3cr3t/')
            AUTH_COMMANDS+=("$auth_subcommand")
        else
            AUTH_COMMANDS+=("$subcommand")
        fi
    done
    PROCESSED_COMMAND=$(printf '%s && ' "${AUTH_COMMANDS[@]}" | sed 's/ && $//')
}

run_commands() {
    start_nats_server
    timeout "$TIMEOUT" bash -c "$PROCESSED_COMMAND"
    if [ $? -eq 124 ]; then
        stop_nats_server
        echo "⏰ Execution timed out after ${TIMEOUT} seconds."
        exit 124
    fi
}

main() {
    parse_args "$@"
    read_command_from_stdin
    preprocess_command
    add_auth_flags
    run_commands
}

main "$@"
