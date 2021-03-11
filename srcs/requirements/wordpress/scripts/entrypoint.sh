#!/bin/sh
#
# Docker entrypoint

# Exit immediately if a command exits with a non-zero status
set -e

nginx -g "daemon off;"

exec "$@"
