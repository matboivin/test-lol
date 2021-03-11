FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13
ENV PHP_VERSION=7.4.15-r0
ENV WORDPRESS_VERSION=5.6.2
ENV SERVER_USER=nginx
ENV WP_ROOT_DIR=/var/www/localhost/wordpress

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION} \
    php7 php7-fpm \
    php7-curl php7-dom php7-exif php7-fileinfo php7-json php7-mbstring \
    php7-mysqli php7-sodium php7-openssl php7-imagick php7-xml php7-zip \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default \
 && rm /etc/nginx/conf.d/default.conf

# Add necessary scripts
COPY scripts/ /opt/

# Create group and user for NGINX, app dir, and grant permissions
RUN mkdir -p /run/nginx/ $WP_ROOT_DIR \
 && chown -R $SERVER_USER:$SERVER_USER /var/www/localhost/ /run /var/lib/nginx

# Generate a self-signed certificate and private key using OpenSSL
RUN sh /opt/gen_key.sh

# Add config and HTML files
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/
COPY www/ $WP_ROOT_DIR

# Get and setup WordPress
RUN cd $WP_ROOT_DIR && wget https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
 && tar -zxvf wordpress-${WORDPRESS_VERSION}.tar.gz \
 && rm wordpress-${WORDPRESS_VERSION}.tar.gz
#COPY config/wp-config.php $WP_ROOT_DIR
# WordPress styling
#COPY theme/cyanotype $WP_ROOT_DIR/wp-content/themes/cyanotype
#COPY www/favicon.ico $WP_ROOT_DIR/wp-content/uploads/2020/05/
#COPY theme/42wallpaper.jpg $WP_ROOT_DIR/wp-content/uploads/2020/05/

# Inform which ports are intended to be published
EXPOSE 5050

ENTRYPOINT ["sh", "/opt/entrypoint.sh"]
#CMD ["/usr/sbin/php7-fpm"]
