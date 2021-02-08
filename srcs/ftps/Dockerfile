FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

ENV FTP_USER=user42
ENV FTP_PASSWD=user42

# Install necessary packages and backup default vsftpd config
RUN apk add --no-cache vsftpd \
 && mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig

# Create group and user
RUN addgroup -S $FTP_USER \
 && adduser -D -h /home/$FTP_USER -s /sbin/nologin -G $FTP_USER $FTP_USER \
 && echo "user42:user42" | chpasswd

# Inform which ports are intended to be published
EXPOSE 21
