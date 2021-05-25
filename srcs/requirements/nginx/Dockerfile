FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION}
# Backup default NGINX config and create necessary directories
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default \
 && rm /etc/nginx/conf.d/default.conf \
 && mkdir -p /run/nginx/ /var/www/localhost/html /var/www/localhost/img /etc/nginx/sites-enabled

# Add necessary scripts
COPY scripts/ /opt/

# Generate a self-signed certificate and private key using OpenSSL
RUN sh /opt/gen_key.sh

# Add NGINX config and HTML files
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/
COPY html/ /var/www/localhost/html
COPY img/ /var/www/localhost/img

# Symlink to sites-available to enable vhost
RUN ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/

# Grant permissions to server user
RUN chown -R nginx:nginx /run /var/lib/nginx /var/www

# Inform which ports are intended to be published
EXPOSE 80 443

ENTRYPOINT ["sh", "/opt/docker_entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
