FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Install necessary packages
RUN apk add --no-cache

# Environment Variables
ENV USER=www-data

# Install necessary packages and backup default vsftpd config
RUN apk add --no-cache vsftpd vsftpd-doc \
 && mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.orig

# Create group and user
RUN addgroup --system $USER \
 && adduser \
    --system \
    --disabled-password \
    --home /home/$USER \
    --shell /sbin/nologin \
    --ingroup $USER \
    $USER \

RUN mkdir -p var/www/

# Get and setup WordPress
RUN cd /tmp/ && wget https://wordpress.org/latest.tar.gz \
 && tar -C /var/www/ -xvf latest.tar.gz \
 && chown -R www-data:www-data /var/www/wordpress
#COPY config/wordpress/wp-config.php /var/www/wordpress
# WordPress styling
COPY config/wordpress/cyanotype /var/www/wordpress/wp-content/themes/cyanotype
COPY config/favicon.ico /var/www/wordpress/wp-content/uploads/2020/05/
COPY config/wordpress/42wallpaper.jpg /var/www/wordpress/wp-content/uploads/2020/05/

# Inform which ports are intended to be published
EXPOSE 5050
