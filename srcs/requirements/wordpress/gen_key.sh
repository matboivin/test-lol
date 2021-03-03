#!/bin/sh
#
# Generate a self-signed certificate and private key using OpenSSL

CERT_PATH=/etc/ssl/certs/
CERT_FILE=localhost.crt
KEY_FILE=localhost.key

apk update && apk add --no-cache openssl
cd $CERT_PATH
openssl req -x509 -days 90 \
    -out $CERT_FILE \
    -keyout $KEY_FILE \
    -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' \
&& chown 0600 $CERT_PATH/$KEY_FILE $CERT_PATH/$CERT_FILE
