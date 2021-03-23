FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13
ENV WORDPRESS_VERSION=5.6.2

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION} \
    php7 php7-fpm \
    php7-curl php7-dom php7-exif php7-fileinfo php7-json php7-mbstring \
    php7-mysqli php7-sodium php7-openssl php7-imagick php7-xml php7-zip \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default \
 && rm /etc/nginx/conf.d/default.conf \
 && mkdir -p /run/nginx/ /var/www/localhost

# Add necessary scripts
COPY scripts/ /opt/

# Generate a self-signed certificate and private key using OpenSSL
RUN sh /opt/gen_key.sh

# Add config and HTML files
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/

# Get and setup WordPress
RUN cd /var/www && wget https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
 && tar -zxvf wordpress-${WORDPRESS_VERSION}.tar.gz \
 && rm wordpress-${WORDPRESS_VERSION}.tar.gz
COPY www/ /var/www/wordpress
COPY config/wp-config.php /var/www/wordpress
#COPY www/favicon.ico /var/www/wordpress/wp-content/uploads/2021/03/
#COPY wp-theme/cyanotype /var/www/wordpress/wp-content/themes/cyanotype
#COPY wp-theme/42wallpaper.jpg /var/www/wordpress/wp-content/uploads/2021/03/

# Create server user
RUN adduser --disabled-password --no-create-home --uid 1000 www-data --ingroup www-data \
 && chown -R www-data:www-data /run /var/lib/nginx /var/www

# Inform which ports are intended to be published
EXPOSE 5050

ENTRYPOINT ["sh", "/opt/entrypoint.sh"]
CMD ["/bin/sh", "-c", "php-fpm7; nginx -g 'daemon off;'"]
