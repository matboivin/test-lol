#!/bin/sh
#
# Docker entrypoint

# Exit immediately if a command exits with a non-zero status
set -e

# Create group and user
addgroup --system $FTP_USER
adduser \
    --system \
    --disabled-password \
    --home /home/$FTP_USER \
    --shell /sbin/nologin \
    --ingroup $FTP_USER \
    $FTP_USER
echo "$FTP_USER:$FTP_PASS" | chpasswd

# Secure chroot jail
chown root:root /home/$FTP_USER
mkdir -p /home/$FTP_USER/files
chown $FTP_USER:$FTP_USER /home/$FTP_USER/files

exec "$@"
