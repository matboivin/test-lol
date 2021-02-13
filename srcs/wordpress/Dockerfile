FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Install necessary packages
RUN apk add --no-cache php

# Environment Variables
ENV USER=www-data

# Install necessary packages
RUN apk add --no-cache php7.3-fpm php7.3-mysql php7.3-gd php7.3-mbstring php7.3-xml php-pear php7.3-gettext php7.3-cgi php7.3-zip

# Create group and user
RUN addgroup --system $USER \
 && adduser \
    --system \
    --disabled-password \
    --home /home/$USER \
    --shell /sbin/nologin \
    --ingroup $USER \
    $USER

# Get and setup WordPress
RUN mkdir -p var/www/ \
 && cd /tmp/ && wget https://wordpress.org/latest.tar.gz \
 && tar -C /var/www/ -xvf latest.tar.gz \
 && chown -R www-data:www-data /var/www/wordpress
#COPY config/wordpress/wp-config.php /var/www/wordpress
# WordPress styling
COPY config/cyanotype /var/www/wordpress/wp-content/themes/cyanotype
COPY config/favicon.ico /var/www/wordpress/wp-content/uploads/2020/05/
COPY config/42wallpaper.jpg /var/www/wordpress/wp-content/uploads/2020/05/

# Inform which ports are intended to be published
EXPOSE 5050
