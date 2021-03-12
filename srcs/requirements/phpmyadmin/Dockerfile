FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13
ENV PMA_VERSION=5.1.0
ENV PMA_ROOT_DIR=/var/www/localhost/phpmyadmin

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION} \
     php7 php7-fpm \
     php7-ctype php7-dom php7-curl php7-cgi fcgi \
     php7-gettext php7-gd php7-iconv php7-imap php7-json php7-mbstring php7-mysqli \
     php7-pdo php7-pdo_mysql php7-mcrypt php7-posix php7-soap php7-xml php7-xmlrpc \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default \
 && rm /etc/nginx/conf.d/default.conf \
 && mkdir -p /run/nginx/ $PMA_ROOT_DIR

# Add necessary scripts
COPY scripts/ /opt/

# Generate a self-signed certificate and private key using OpenSSL
RUN sh /opt/gen_key.sh

# Add config and HTML files
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/
COPY www/ $PMA_ROOT_DIR

# Get and set up phpMyAdmin
RUN cd $PMA_ROOT_DIR && wget https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz \
 && tar -xvf phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz --strip 1 \
 && rm phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz
#COPY config.inc.php $PMA_ROOT_DIR

# Grant permissions
RUN chown -R nginx:nginx /var/www/localhost/ /run /var/lib/nginx

# Inform which ports are intended to be published
EXPOSE 5000

ENTRYPOINT ["sh", "/opt/entrypoint.sh"]
CMD ["php-fpm7"]
