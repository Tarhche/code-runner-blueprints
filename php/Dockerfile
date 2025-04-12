# Accept PHP version as build argument
ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-cli-alpine

# Install bash + timeout utility
RUN apk add --no-cache bash coreutils

WORKDIR /app

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
