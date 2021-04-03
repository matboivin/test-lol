#!/bin/sh
#
# Generate a self-signed certificate and private key using OpenSSL

apk update && apk add --no-cache openssl
openssl req -x509 -sha256 -nodes -days 90 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/vsftpd-selfsigned.key \
    -out /etc/ssl/certs/vsftpd-selfsigned.crt \
    -subj '/C=FR/CN=ftps'
chmod 0600 /etc/ssl/private/vsftpd-selfsigned.key /etc/ssl/certs/vsftpd-selfsigned.crt
