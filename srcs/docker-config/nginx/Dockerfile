FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Install necessary packages and backup default NGINX config
RUN apk add --no-cache nginx=1.18.0-r13 openssl \
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
 && mkdir -p /run/nginx/ \
 && chown -R www:www /var/www/localhost/ \
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

# Inform which ports are intended to be published
EXPOSE 80 443

# Run server
CMD ["nginx", "-g", "daemon off;"]
