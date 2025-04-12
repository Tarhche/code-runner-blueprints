# Accept Nodejs version as build argument
ARG NODEJS_VERSION=22.14

FROM node:${NODEJS_VERSION}-alpine

# Install bash + timeout utility
RUN apk add --no-cache bash coreutils

WORKDIR /app

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
