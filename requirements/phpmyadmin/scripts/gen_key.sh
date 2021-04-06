#!/bin/sh
#
# Generate a self-signed certificate and private key using OpenSSL

apk update && apk add --no-cache openssl
openssl req -x509 -sha256 -nodes -days 90 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj '/C=FR/CN=mydomain'
chmod 0600 /etc/ssl/private/nginx-selfsigned.key /etc/ssl/certs/nginx-selfsigned.crt
