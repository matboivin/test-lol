#!/bin/sh
#
# Docker entrypoint

# Exit immediately if a command exits with a non-zero status
set -e

if ! id -u "$FTP_USER" > /dev/null 2>&1; then
    # Create FTP user
    adduser --disabled-password $FTP_USER
    echo "$FTP_USER:$FTP_PASS" | chpasswd
    chown -R $FTP_USER /home/$FTP_USER
fi

"$@"
