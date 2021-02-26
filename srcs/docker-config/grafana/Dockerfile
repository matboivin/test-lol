FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV GRAFANA_VERSION=7.4.3

# Install necessary packages
RUN apk add update \
 && cd /tmp/
 && wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
 && tar -zxvf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
 && rm grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz

# Inform which ports are intended to be published
EXPOSE 3000
