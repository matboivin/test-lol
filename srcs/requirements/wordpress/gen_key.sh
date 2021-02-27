#!/bin/sh
#
# Generate a self-signed certificate and private key using OpenSSL

apk add --no-cache openssl
cd /etc/ssl/certs/
openssl req -x509 -days 90 \
    -out localhost.crt \
    -keyout localhost.key \
    -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' \
&& chown 0600 /etc/ssl/certs/localhost.key /etc/ssl/certs/localhost.crt
