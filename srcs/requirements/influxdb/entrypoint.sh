#!/bin/sh
#
# Start influxd

# Exit immediately if a command exits with a non-zero status
set -e

exec /usr/sbin/influxd
