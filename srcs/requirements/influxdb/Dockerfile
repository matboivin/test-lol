FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV INFLUXDB_VERSION=1.8.3-r2

# Install necessary packages
RUN apk update \
 && apk add --no-cache influxdb=${INFLUXDB_VERSION}

# Inform which ports are intended to be published
EXPOSE 8086
