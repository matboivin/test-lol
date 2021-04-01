FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13
ENV WORDPRESS_VERSION=5.7

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION} \
    php7 php7-common php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli \
    php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix \
    php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom php7-fpm php7-opcache \
    php7-exif php7-fileinfo php7-mbstring php7-sodium php7-openssl php7-zip php7-simplexml \
    php7-xmlreader php7-zlib \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default \
 && rm /etc/nginx/conf.d/default.conf \
 && mkdir -p /run/nginx /etc/nginx/sites-enabled

# Add necessary scripts
COPY scripts/ /opt/

# Generate a self-signed certificate and private key using OpenSSL
RUN sh /opt/gen_key.sh

# Add config files
# NGINX
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/

# Get and setup WordPress
RUN cd /var/www && wget https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
 && tar -zxvf wordpress-${WORDPRESS_VERSION}.tar.gz \
 && rm wordpress-${WORDPRESS_VERSION}.tar.gz \
 && mkdir -p /var/www/wordpress/wp-content/uploads/2021/03/ /var/www/wordpress/html
COPY html/ /var/www/wordpress/html
COPY wp-theme/cyanotype /var/www/wordpress/wp-content/themes/cyanotype
COPY wp-theme/42wallpaper.jpg /var/www/wordpress/wp-content/uploads/2021/03/

# Symlink to sites-available to enable vhost
RUN ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/

# Grant permissions to server user
RUN chown -R nginx:nginx /run /var/lib/nginx /var/www

# Inform which ports are intended to be published
EXPOSE 5050

ENTRYPOINT ["sh", "/opt/docker-entrypoint.sh"]
CMD ["/bin/sh", "-c", "php-fpm7 && nginx -g 'daemon off;'"]
