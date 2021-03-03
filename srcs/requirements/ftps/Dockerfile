FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV FTP_USER=user42
ENV FTP_PASS=user42

# Install necessary packages and backup default vsftpd config
RUN apk update \
 && apk add --no-cache vsftpd \
 && mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig

# Create group and user
RUN mkdir -p /var/ftp \
 && addgroup --system $FTP_USER \
 && adduser \
    --system \
    --disabled-password \
    --home /home/$FTP_USER \
    --shell /sbin/nologin \
    --ingroup $FTP_USER \
    $FTP_USER \
 && echo "$FTP_USER:$FTP_PASS" | chpasswd

# Generate a self-signed certificate and private key using OpenSSL
COPY gen_key.sh /tmp
RUN sh /tmp/gen_key.sh && rm /tmp/gen_key.sh

# Add basic config
COPY vsftpd.conf /etc/vsftpd/

VOLUME ["/var/ftp"]

WORKDIR /var/ftp

# Inform which ports are intended to be published
EXPOSE 21

ENTRYPOINT ["vsftpd" "/etc/vsftpd/vsftpd.conf"]
