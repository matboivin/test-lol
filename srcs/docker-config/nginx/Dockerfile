FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Install necessary packages and backup default NGINX config
RUN apk add --no-cache nginx openssl \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

# Add new config
COPY config/nginx.conf /etc/nginx/
# Add index and favicon
COPY config/index.html var/www/
COPY config/favicon.ico var/www/

# Create new user and group for NGINX, create a directory for HTML files and grant permissions
RUN adduser -D -g 'www' www \
 && mkdir -p var/www/ \
 && chown -R www:www /var/www \
 && chown -R www:www /var/lib/nginx \
 && chown -R www:www /run

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
