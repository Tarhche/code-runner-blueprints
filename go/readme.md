This Dockerfile will creates a docker image which can be used to run a go code with a timeout.

# How to build

```
# building with go 1.24
docker build --build-arg GO_VERSION=1.24 -t go-code-runner:1.24 .

# building with go 1.23
docker build --build-arg GO_VERSION=1.23 -t go-code-runner:1.23 .
```

The Go version can be specified by passing the `GO_VERSION` argument to the `docker build` command.

# How to use

1. Run code with default timeout

```sh
docker run --rm go-code-runner:1.23 'package main; import("fmt"); func main() { fmt.Println("Hello!") }'
```

2. Run code with custom timeout

```sh
docker run --rm go-code-runner:1.24 --timeout 3 'package main; import("time"); func main() { time.Sleep(5 * time.Second) }'
```

3. Multiline + custom timeout

```sh
docker run --rm -i go-code-runner:1.24 --timeout 5 <<EOF
package main

import (
    "fmt"
    "time"
)

func main() {
    for i := 0; i < 10; i++ {
        fmt.Println("Tick", i)
        time.Sleep(time.Second)
    }
}
EOF
```