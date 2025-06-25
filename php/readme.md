This Dockerfile will creates a docker image which can be used to run a JS code with a timeout.

# How to build

```
# building with PHP 8.4
docker build --build-arg PHP_VERSION=8.4 -t code-runner:php-8.4 .
```

The PHP version can be specified by passing the `PHP_VERSION` argument to the `docker build` command.

# How to use

1. Run code with default timeout

```sh
docker run --rm code-runner:php-8.4 '<?php echo "Hello from PHP\n"; sleep(2);'
```

2. Run code with custom timeout

```sh
docker run --rm code-runner:php-8.4 --timeout 3 '<?php while(true) { echo "Looping\n"; sleep(1); }'
```

3. Multiline + custom timeout

```sh
docker run --rm -i code-runner:php-8.4 --timeout 5 <<EOF
<?php
echo "Starting...\n";

for (\$i = 0; \$i < 20; \$i++) {
    echo "Tick \$i\n";
    sleep(1);
}
EOF
```
