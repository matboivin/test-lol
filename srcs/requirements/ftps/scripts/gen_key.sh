#!/bin/sh
#
# Generate a self-signed certificate and private key using OpenSSL

CERT_FILE=vsftpd.crt
KEY_FILE=vsftpd.key

apk update && apk add --no-cache openssl
cd /etc/ssl/private
openssl req -x509 -sha256 -nodes -days 90 \
    -newkey rsa:2048 \
    -keyout $KEY_FILE \
    -out $CERT_FILE \
    -subj '/C=FR/CN=localhost' \
&& chown 0600 /etc/ssl/private/$KEY_FILE /etc/ssl/private/$CERT_FILE
