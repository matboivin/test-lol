FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV SRV_USER=user42
ENV SRV_PASSWD=user42

# Install necessary packages and backup default vsftpd config
RUN apk update \
 && apk add --no-cache vsftpd vsftpd-doc \
 && mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig

# Create group and user
RUN mkdir -p /var/ftp \
 && addgroup --system $SRV_USER \
 && adduser \
    --system \
    --disabled-password \
    --home /home/$SRV_USER \
    --shell /sbin/nologin \
    --ingroup $SRV_USER \
    $SRV_USER \
 && echo "$SRV_USER:$SRV_PASSWD" | chpasswd

# Add basic config
COPY vsftpd.conf /etc/vsftpd/

VOLUME ["/var/ftp"]

WORKDIR /var/ftp

# Inform which ports are intended to be published
EXPOSE 20 21

ENTRYPOINT ["vsftpd" "/etc/vsftpd/vsftpd.conf"]
