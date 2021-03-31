FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV GRAFANA_VERSION=7.3.6-r0
ENV GF_PATHS_HOME="/usr/share/grafana"
ENV GF_PATHS_CONFIG="/etc/grafana/grafana.ini"
ENV GF_PATHS_PROVISIONING="/usr/share/grafana/conf/provisioning"
ENV GF_PATHS_PLUGINS="/usr/share/grafana/conf/provisioning/plugins"

# Install necessary packages
RUN apk update \
 && apk add --no-cache grafana=${GRAFANA_VERSION}

# Add necessary scripts
COPY scripts/ /opt/

# Create Grafana directories
RUN mkdir -p "/etc/grafana" \
 && mv /etc/grafana.ini "$GF_PATHS_CONFIG" \
 && rm -f "/usr/share/grafana/conf/provisioning/dashboards/sample.yaml" \
          "/usr/share/grafana/conf/provisioning/datasources/sample.yaml" \
 && chown -R grafana:grafana "$GF_PATHS_HOME" "/etc/grafana"

# Where Grafana by default will write its data files
VOLUME ["/usr/share/grafana/data"]

WORKDIR $GF_PATHS_HOME

# Inform which ports are intended to be published
EXPOSE 3000

ENTRYPOINT ["sh", "/opt/docker-entrypoint.sh"]
CMD ["/usr/sbin/grafana-server"]
