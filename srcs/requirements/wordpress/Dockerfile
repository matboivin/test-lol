FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13
ENV WORDPRESS_VERSION=5.6.2
ENV SERVER_USER=nginx
ENV WP_ROOT_DIR=/var/www/localhost/wordpress

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION} \
    php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig \
 && rm /etc/nginx/conf.d/default.conf

# Create group and user for NGINX, app dir, and grant permissions
RUN mkdir -p /run/nginx/ $WP_ROOT_DIR \
 && chown -R $SERVER_USER:$SERVER_USER /var/www/localhost/ /run /var/lib/nginx

# Generate a self-signed certificate and private key using OpenSSL
COPY gen_key.sh /tmp
RUN sh /tmp/gen_key.sh && rm /tmp/gen_key.sh

# Add config and HTML files
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/
COPY www/ $WP_ROOT_DIR

# Get and setup WordPress
RUN chown -R www:www $WP_ROOT_DIR \
 && cd $WP_ROOT_DIR && wget https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
 && tar -zxvf wordpress-${WORDPRESS_VERSION}.tar.gz \
 && rm wordpress-${WORDPRESS_VERSION}.tar.gz
#COPY config/wp-config.php $WP_ROOT_DIR
# WordPress styling
#COPY theme/cyanotype $WP_ROOT_DIR/wp-content/themes/cyanotype
#COPY www/favicon.ico $WP_ROOT_DIR/wp-content/uploads/2020/05/
#COPY theme/42wallpaper.jpg $WP_ROOT_DIR/wp-content/uploads/2020/05/

# Inform which ports are intended to be published
EXPOSE 5050

# Run server
CMD ["nginx", "-g", "daemon off;"]
