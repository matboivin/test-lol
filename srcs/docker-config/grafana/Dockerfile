FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV GRAFANA_VERSION=7.4.3
ENV GF_PATHS_CONFIG=/etc/grafana/grafana.ini
ENV GF_PATHS_DATA=/var/lib/grafana
ENV GF_PATHS_HOME=/usr/share/grafana
ENV GF_PATHS_LOGS=/var/log/grafana
ENV GF_PATHS_PLUGINS=/var/lib/grafana/plugins
ENV GF_PATHS_PROVISIONING=/etc/grafana/provisioning
# Update PATH to use grafana-cli
ENV PATH="$PATH:/usr/share/grafana/bin/"

# Install necessary packages
#RUN apk update

# Install Grafana
RUN mkdir -p $GF_PATHS_HOME $GF_PATHS_LOGS $GF_PATHS_PLUGINS $GF_PATHS_PROVISIONING \
 && adduser -D -g 'grafana' grafana \
 && chown -R grafana:grafana $GF_PATHS_HOME $GF_PATHS_LOGS $GF_PATHS_DATA "/etc/grafana" \
 && cd $GF_PATHS_HOME \
 && wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
 && tar -zxvf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz --strip-components 1 \
 && rm grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz

WORKDIR $GF_PATHS_HOME

# Inform which ports are intended to be published
EXPOSE 3000
