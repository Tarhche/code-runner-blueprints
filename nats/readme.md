This Dockerfile will creates a docker image which can be used to run `nats` commands.

# How to build

```
# building with nats-server 2.10.0
docker build --build-arg NATS_SERVER_VERSION=2.10.0 -t code-runner:nats-2.10.0 .
```

The Nats version can be specified by passing the `NATS_SERVER_VERSION` argument to the `docker build` command.

# How to use

1. Run code with default timeout

```sh
docker run --rm code-runner:nats-2.10.0 'nats --user=mahdi account info'
```

2. Run code with custom timeout

```sh
docker run --rm code-runner:nats-2.10.0 --timeout 3 'nats --user=mahdi account info'
```

3. Multiline + custom timeout

```sh
docker run --rm -i code-runner:nats-2.10.0 --timeout 5 <<EOF
nats account info && \
nats stream ls
EOF
```
