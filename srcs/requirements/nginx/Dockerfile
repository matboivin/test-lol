FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13
ENV SERVER_USER=www

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION} \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig \
 && rm /etc/nginx/conf.d/default.conf

# Add config files
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/
# Add pages and favicon
COPY www/ /var/www/localhost/

# Create group and user for NGINX, app dir, and grant permissions
RUN addgroup --system $SERVER_USER \
 && adduser \
    --system \
    --disabled-password \
    --ingroup $SERVER_USER \
    $SERVER_USER \
 && mkdir -p /run/nginx/ \
 && chown -R $SERVER_USER:$SERVER_USER /var/www/localhost/ /run /var/lib/nginx

# Generate a self-signed certificate and private key using OpenSSL
COPY gen_key.sh /tmp
RUN sh /tmp/gen_key.sh && rm /tmp/gen_key.sh

# Inform which ports are intended to be published
EXPOSE 80 443

# Run server
CMD ["nginx", "-g", "daemon off;"]
