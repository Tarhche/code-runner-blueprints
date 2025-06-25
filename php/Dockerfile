# Accept PHP version as build argument
ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-cli-alpine

RUN apk add --no-cache bash coreutils shadow

WORKDIR /home/runner

COPY run.sh /run.sh

RUN groupadd -g 10001 runner \
    && useradd -u 10000 -g runner -m -d /home/runner runner \
    && chown -R runner:runner /home/runner \
    && chmod +x /run.sh

USER runner:runner

ENTRYPOINT ["/run.sh"]
