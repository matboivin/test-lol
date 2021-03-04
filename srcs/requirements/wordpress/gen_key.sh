#!/bin/sh
#
# Generate a self-signed certificate and private key using OpenSSL

CERT_PATH=/etc/ssl/certs/
CERT_FILE=localhost.crt
KEY_FILE=localhost.key

apk update && apk add --no-cache openssl
cd $CERT_PATH
openssl req -x509 -sha256 -nodes -days 90 \
    -newkey rsa:2048 \
    -keyout $KEY_FILE \
    -out $CERT_FILE \
    -subj '/C=FR/CN=localhost' \
&& chown 0600 $CERT_PATH/$KEY_FILE $CERT_PATH/$CERT_FILE
