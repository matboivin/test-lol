FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV FTP_VERSION=3.0.3-r6
ENV FTP_USER=user42
ENV FTP_PASS=user42
ENV FTP_ANON_DIR=/var/ftp

# Install necessary packages and backup default vsftpd config
RUN apk update \
 && apk add --no-cache vsftpd=${FTP_VERSION} \
 && mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.default

# Create group and user
RUN mkdir -p /etc/vsftpd/vsftpd_user_conf $FTP_ANON_DIR \
 && addgroup --system $FTP_USER \
 && adduser \
    --system \
    --disabled-password \
    --home /home/$FTP_USER \
    --shell /sbin/nologin \
    --ingroup $FTP_USER \
    $FTP_USER \
 && echo "$FTP_USER:$FTP_PASS" | chpasswd
# Secure chroot jail
RUN chown root:root /home/$FTP_USER \
 && mkdir -p /home/$FTP_USER/files \
 && chown $FTP_USER:$FTP_USER /home/$FTP_USER/files

# Generate a self-signed certificate and private key using OpenSSL
COPY gen_key.sh /tmp
RUN sh /tmp/gen_key.sh && rm /tmp/gen_key.sh

# Add config files
COPY config/ /etc/vsftpd/
COPY user_conf/ /etc/vsftpd/vsftpd_user_conf

WORKDIR /etc/vsftpd

# Inform which ports are intended to be published
EXPOSE 21

ENTRYPOINT ["/usr/sbin/vsftpd" "/etc/vsftpd/vsftpd.conf"]
