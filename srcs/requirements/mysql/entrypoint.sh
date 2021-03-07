#!/bin/sh
#
# Start mysqld

# Exit immediately if a command exits with a non-zero status
set -e

exec /usr/bin/mysqld_safe --datadir=/var/lib/mysql
