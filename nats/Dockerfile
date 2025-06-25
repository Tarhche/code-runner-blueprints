# Accept Nats server version as build argument
ARG NATS_SERVER_VERSION=2.10.0

# ------------------------------------------
FROM nats:${NATS_SERVER_VERSION}-alpine AS base

# ------------------------------------------
FROM base AS builder

COPY install.sh /tmp/install.sh

RUN chmod +x /tmp/install.sh && /tmp/install.sh

# ------------------------------------------
FROM base AS runner

# Install tools
RUN apk add --no-cache bash coreutils busybox-extras shadow

# Create data directory for nats server
RUN mkdir -p /data

# Copy nats binary from builder image
COPY --from=builder /usr/local/bin/nats /usr/local/bin/nats

COPY nats.conf /etc/nats/nats-server.conf

WORKDIR /home/runner

COPY run.sh /run.sh

RUN groupadd -g 10001 runner \
    && useradd -u 10000 -g runner -m -d /home/runner runner \
    && chown -R runner:runner /home/runner /data \
    && chmod +x /run.sh

USER runner:runner

ENTRYPOINT ["/run.sh"]
