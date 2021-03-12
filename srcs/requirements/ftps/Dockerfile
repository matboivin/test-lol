FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV FTP_VERSION=3.0.3-r6
ENV FTP_USER=user42
ENV FTP_PASS=user42

# Install necessary packages and backup default vsftpd config
RUN apk update \
 && apk add --no-cache vsftpd=${FTP_VERSION} vsftpd-doc \
 && mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.default \
 && mkdir -p /etc/vsftpd/vsftpd_user_conf

# Add necessary scripts
COPY scripts/ /opt/

# Generate a self-signed certificate and private key using OpenSSL
RUN sh /opt/gen_key.sh

# Add config files
COPY config/ /etc/vsftpd/
COPY user_conf/ /etc/vsftpd/vsftpd_user_conf/

# Create group and user
RUN addgroup --system $FTP_USER \
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

# Inform which ports are intended to be published
EXPOSE 21 21000 21100

ENTRYPOINT ["sh", "/opt/entrypoint.sh"]
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
