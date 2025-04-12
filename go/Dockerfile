# Accept Go version as build argument
ARG GO_VERSION=1.24

FROM golang:${GO_VERSION}-alpine

RUN apk add --no-cache bash coreutils

WORKDIR /app

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
