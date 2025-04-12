#!/bin/bash

# Default timeout
TIMEOUT=10

# Parse optional --timeout argument
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        *)
            CODE="$1"
            shift
            ;;
    esac
done

# If not provided as argument, check for stdin
if [ -z "$CODE" ] && [ ! -t 0 ]; then
  CODE=$(cat -)
fi

if [ -z "$CODE" ]; then
  echo "No PHP code provided."
  exit 1
fi

echo "$CODE" > script.php

timeout "$TIMEOUT" php script.php

if [ $? -eq 124 ]; then
  echo "⏰ Execution timed out after ${TIMEOUT} seconds."
  exit 124
fi
