FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13
ENV PMA_VERSION=5.1.0

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION} \
    supervisor \
    php7 php7-common php7-session php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli \
    php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix \
    php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom php7-mbstring php7-fpm php7-opcache
# Backup default NGINX config and create necessary directories
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default \
 && rm /etc/nginx/conf.d/default.conf /etc/supervisord.conf \
 && mkdir -p /run/nginx /var/www/phpmyadmin/html /var/www/phpmyadmin/img /etc/nginx/sites-enabled /var/log/supervisor /etc/supervisor

# Add necessary scripts
COPY scripts/ /opt/

# Generate a self-signed certificate and private key using OpenSSL
RUN sh /opt/gen_key.sh

# Add NGINX config
COPY nginx/nginx.conf /etc/nginx/
COPY nginx/localhost.conf /etc/nginx/sites-available/
COPY nginx/conf.d /etc/nginx/conf.d/
# Add supervisord config
COPY config/supervisord.conf /etc/supervisor/supervisord.conf

# Get and set up phpMyAdmin
RUN cd /var/www/phpmyadmin && wget https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz \
 && tar -xvf phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz --strip 1 \
 && rm phpMyAdmin-${PMA_VERSION}-all-languages.tar.gz
COPY html/ /var/www/phpmyadmin/html
COPY img/ /var/www/phpmyadmin/img

# Symlink to sites-available to enable vhost
RUN ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/

# Grant permissions to server user
RUN chown -R nginx:nginx /run /var/lib/nginx /var/www

# Inform which ports are intended to be published
EXPOSE 5000

CMD ["/usr/bin/supervisord", "--configuration", "/etc/supervisor/supervisord.conf"]
