FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV NGINX_VERSION=1.18.0-r13

# Install necessary packages and backup default NGINX config
RUN apk update \
 && apk add --no-cache nginx=${NGINX_VERSION} \
 && mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default \
 && rm /etc/nginx/conf.d/default.conf \
 && mkdir -p /run/nginx/

# Add necessary scripts
COPY scripts/ /opt/

# Generate a self-signed certificate and private key using OpenSSL
RUN sh /opt/gen_key.sh

# Add config and HTML files
COPY config/nginx.conf /etc/nginx/
COPY config/localhost.conf /etc/nginx/sites-available/
COPY config/conf.d /etc/nginx/conf.d/
COPY www/ /var/www/localhost

# Grant permissions
RUN chown -R nginx:nginx /var/www/localhost /run /var/lib/nginx

# Inform which ports are intended to be published
EXPOSE 80 443

ENTRYPOINT ["sh", "/opt/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
