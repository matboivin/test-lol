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

# Grants NGINX user permissions
RUN  mkdir -p var/www/ \
 && mkdir -p run/nginx/ \
 && chown -R nginx:nginx /var/www \
 && chown -R nginx:nginx /var/lib/nginx \
 && chown -R nginx:nginx /var/log/nginx \
 && chown -R nginx:nginx /run

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
