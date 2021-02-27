FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV GRAFANA_VERSION=7.3.6-r0
ENV GF_PATHS_CONFIG=/etc/grafana/grafana.ini
ENV GF_PATHS_DATA=/var/lib/grafana
ENV GF_PATHS_HOME=/usr/share/grafana
ENV GF_PATHS_LOGS=/var/log/grafana
ENV GF_PATHS_PLUGINS=/var/lib/grafana/plugins
ENV GF_PATHS_PROVISIONING=/etc/grafana/provisioning
# Log to /var/log/grafana/grafana.log
ENV GF_LOG_MODE=file

# Install necessary packages
RUN apk update \
 && apk add --no-cache grafana=${GRAFANA_VERSION}

# Create Grafana directories and move config files
RUN mkdir -p $GF_PATHS_LOGS $GF_PATHS_PLUGINS $GF_PATHS_PROVISIONING \
 && mv /etc/grafana.ini $GF_PATHS_CONFIG
# && chown -R grafana:grafana $GF_PATHS_HOME $GF_PATHS_LOGS $GF_PATHS_DATA $GF_PATHS_PLUGINS $GF_PATHS_PROVISIONING

WORKDIR $GF_PATHS_HOME

# Inform which ports are intended to be published
EXPOSE 3000
