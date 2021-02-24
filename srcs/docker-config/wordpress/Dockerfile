FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Install necessary packages and backup default NGINX config
RUN apk add --no-cache nginx=1.18.0-r13 openssl \
    php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

# Add new config
COPY config/nginx.conf /etc/nginx/

# Create new user and group for NGINX, create app and data dirs, and grant permissions
RUN adduser -D -g 'www' www \
 && mkdir -p /var/www/ \
 && mkdir -p /run/nginx/ \
 && chown -R www:www /var/www \
 && chown -R www:www /run \
 && chown -R www:www /var/lib/nginx

# Generate a self-signed certificate and private key using OpenSSL
RUN cd /etc/ssl/certs/ \
 && openssl req -x509 -days 90 \
    -out localhost.crt \
    -keyout localhost.key \
    -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' \
 && chown 600 /etc/ssl/certs/localhost.key /etc/ssl/certs/localhost.crt

# Add index page
COPY config/index.html /var/www/localhost

# Get and setup WordPress
RUN cd /var/www/ && wget https://wordpress.org/latest.tar.gz \
 && tar -xvf latest.tar.gz \
 && chown -R www:www /var/www/wordpress \
 && rm latest.tar.gz
#COPY config/wp-config.php /var/www/wordpress
# WordPress styling
#COPY config/cyanotype /var/www/wordpress/wp-content/themes/cyanotype
#COPY config/favicon.ico /var/www/wordpress/wp-content/uploads/2020/05/
#COPY config/42wallpaper.jpg /var/www/wordpress/wp-content/uploads/2020/05/

# Inform which ports are intended to be published
EXPOSE 5050

# Run server
CMD ["nginx", "-g", "daemon off;"]
