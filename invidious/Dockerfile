ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Install required packages
RUN apk add --no-cache bash curl postgresql postgresql-contrib postgresql-client su-exec docker-cli

# Prepare data directories
RUN mkdir -p /data/db /data/invidious
WORKDIR /data

# Copy addon files
COPY run.sh /run.sh
COPY invidious_config.yml /data/invidious/config.yml
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]