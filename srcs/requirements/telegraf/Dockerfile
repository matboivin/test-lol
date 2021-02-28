FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV TELEGRAF_VERSION=1.17.0-r0

# Install necessary packages
RUN apk update \
 && apk add --no-cache telegraf=${TELEGRAF_VERSION}

# Inform which ports are intended to be published
EXPOSE 8125/udp 8092/udp 8094
