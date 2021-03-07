FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13
ENV PMA_VERSION=5.1.0
ENV SERVER_USER=nginx
ENV PMA_ROOT_DIR=/var/www/localhost/phpmyadmin

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION} \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default \
 && rm /etc/nginx/conf.d/default.conf

# Create group and user for NGINX, app dir, and grant permissions
RUN mkdir -p /run/nginx/ $PMA_ROOT_DIR \
 && chown -R $SERVER_USER:$SERVER_USER /var/www/localhost/ /run /var/lib/nginx

# Generate a self-signed certificate and private key using OpenSSL
COPY gen_key.sh /tmp
RUN sh /tmp/gen_key.sh && rm /tmp/gen_key.sh

# Add config and HTML files
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/
COPY www/ /var/www/localhost

# Get and set up phpMyAdmin
RUN cd $PMA_ROOT_DIR && wget https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz \
 && tar -xvf phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz --strip 1 \
 && rm phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz
#COPY config.inc.php $PMA_ROOT_DIR

# Inform which ports are intended to be published
EXPOSE 5000

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
