FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Install necessary packages and backup default vsftpd config
RUN apk add --no-cache vsftpd \
 && mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig

# Inform which ports are intended to be published
EXPOSE 21
