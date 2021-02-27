FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13
ENV WORDPRESS_VERSION=5.6.2

# Install necessary packages and backup default NGINX config
RUN apk add --no-cache nginx=${NGINX_VERSION} \
    php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig \
 && rm /etc/nginx/conf.d/default.conf

# Add config files
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/
# Add pages and favicon
COPY www/ /var/www/localhost/

# Create new user and group for NGINX, create app and data dirs, and grant permissions
RUN adduser -D -g 'www' www \
 && mkdir -p /run/nginx \
 && chown -R www:www /var/www/localhost/ /run /var/lib/nginx

# Generate a self-signed certificate and private key using OpenSSL
COPY gen_key.sh /tmp
RUN sh /tmp/gen_key.sh && rm /tmp/gen_key.sh

# Get and setup WordPress
RUN mkdir -p /var/www/wordpress \
 && chown -R www:www /var/www/wordpress \
 && cd /var/www/wordpress && wget https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
 && tar -zxvf wordpress-${WORDPRESS_VERSION}.tar.gz \
 && rm wordpress-${WORDPRESS_VERSION}.tar.gz
#COPY config/wp-config.php /var/www/wordpress
# WordPress styling
#COPY config/cyanotype /var/www/wordpress/wp-content/themes/cyanotype
#COPY config/favicon.ico /var/www/wordpress/wp-content/uploads/2020/05/
#COPY config/42wallpaper.jpg /var/www/wordpress/wp-content/uploads/2020/05/

# Inform which ports are intended to be published
EXPOSE 5050

# Run server
CMD ["nginx", "-g", "daemon off;"]
