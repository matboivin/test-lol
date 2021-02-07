FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Install necessary packages and backup default NGINX config
RUN apk add --no-cache nginx openssl \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
# && rm /etc/nginx/conf.d/default.con

# Add new config
COPY config/nginx.conf /etc/nginx/nginx.conf

# Create new user and group 'www' for NGINX and create a directory for HTML files
RUN adduser -D -g 'www' www \
 && mkdir -p var/www/ \
 && chown -R www:www /var/lib/nginx \
 && chown -R www:www /run \
 && chown -R www:www /var/www

# Add index and favicon
COPY config/index.html var/www/
COPY config/favicon.ico var/www/

# Become the www non-root user
USER www

# Inform which ports are intended to be published
EXPOSE 80 443
