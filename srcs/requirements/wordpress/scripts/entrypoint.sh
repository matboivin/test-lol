#!/bin/sh
#
# Docker entrypoint

# Exit immediately if a command exits with a non-zero status
set -e

STARTUP_FILE=/root/scripts/startup.sh

if [[ -f "$STARTUP_FILE" ]]; then
  chmod +x "$STARTUP_FILE" && ."$STARTUP_FILE"
fi

nginx -g "daemon off;"

exec "$@"
