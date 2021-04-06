#!/bin/sh
#
# Docker entrypoint

# Exit immediately if a command exits with a non-zero status
set -e

# Init database
if [[ -f "/opt/init_db.sh" ]]; then
  chmod +x /opt/init_db.sh && ./opt/init_db.sh
fi

exec "$@"
