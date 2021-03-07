#!/bin/sh
#
# Start grafana

# Exit immediately if a command exits with a non-zero status
set -e

exec /usr/sbin/grafana-server -homepath $GF_PATHS_HOME -pidfile /var/log/grafana/grafana.log
