FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Install necessary packages and remove default NGINX config
RUN apk add --no-cache nginx openssl \
 && rm /etc/nginx/conf.d/default.conf

# Add new config
COPY config/nginx.conf /etc/nginx/nginx.conf

# Create directory
RUN mkdir -p /var/www/html/ \
 && chown -R www-data:www-data /var/www/html \
 && chown -R www-data:www-data /run

# Add index and favicon
COPY config/index.html /var/www/html/
COPY config/favicon.ico /var/www/

# Become the www-data non-root user
USER www-data

# Inform which ports are intended to be published
EXPOSE 80 443
