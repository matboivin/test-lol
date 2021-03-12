#!/bin/sh
#
# Generate a self-signed certificate and private key using OpenSSL

CERT_FILE=localhost.crt
KEY_FILE=localhost.key

apk update && apk add --no-cache openssl
mkdir -p /etc/nginx/ssl
cd /etc/nginx/ssl
openssl req -x509 -sha256 -nodes -days 90 \
    -newkey rsa:2048 \
    -keyout $KEY_FILE \
    -out $CERT_FILE \
    -subj '/C=FR/CN=localhost' \
&& chown 0600 /etc/nginx/ssl/$KEY_FILE /etc/nginx/ssl/$CERT_FILE
