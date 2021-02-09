FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

ENV FTP_USER=user42
ENV FTP_PASSWD=user42

# Install necessary packages and backup default vsftpd config
RUN apk add --no-cache vsftpd vsftpd-doc \
 && mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig

# Create group and user
RUN addgroup --system $FTP_USER \
 && adduser \
    --system \
    --disabled-password \
    --home /home/$FTP_USER \
    --shell /sbin/nologin \
    --ingroup $FTP_USER \
    $FTP_USER \
 && echo "$FTP_USER:$FTP_PASSWD" | chpasswd

# Add new config
COPY config/vsftpd.conf /etc/vsftpd/

# Inform which ports are intended to be published
EXPOSE 20 21
