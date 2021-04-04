FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV FTP_VERSION=3.0.3-r6

# Install necessary packages
RUN apk update \
 && apk add --no-cache vsftpd=${FTP_VERSION} \
 && mkdir -p /etc/vsftpd/vsftpd_user_conf /var/run/vsftpd/empty

# Add necessary scripts
COPY scripts/ /opt/

# Generate a self-signed certificate and private key using OpenSSL
RUN sh /opt/gen_key.sh

# Inform which ports are intended to be published
EXPOSE 21 20 20000-20001

ENTRYPOINT ["sh", "/opt/docker-entrypoint.sh"]
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf"]
