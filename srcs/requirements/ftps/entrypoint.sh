#!/bin/sh
#
# Start vsftpd

# Exit immediately if a command exits with a non-zero status
set -e

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
