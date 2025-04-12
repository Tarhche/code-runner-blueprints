This Dockerfile will creates a docker image which can be used to run a JS code with a timeout.

# How to build

```
# building with nodejs 22.14
docker build --build-arg NODEJS_VERSION=22.14 -t code-runner:nodejs-22.14 .
```

The Nodejs version can be specified by passing the `NODEJS_VERSION` argument to the `docker build` command.

# How to use

1. Run code with default timeout

```sh
docker run --rm code-runner:nodejs-22.14 'console.log("Hello from Node.js");'
```

2. Run code with custom timeout

```sh
docker run --rm code-runner:nodejs-22.14 --timeout 3 'setInterval(() => console.log("Still running..."), 1000);'
```

3. Multiline + custom timeout

```sh
docker run --rm -i code-runner:nodejs-22.14 --timeout 5 <<EOF
console.log("Start ticking...");
let i = 0;
setInterval(() => {console.log("Tick", i++);}, 1000);
EOF
```