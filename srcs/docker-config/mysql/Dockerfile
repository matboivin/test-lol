FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV MYSQL_DATABASE=wordpress_db
ENV MYSQL_USER=user42
ENV MYSQL_PASSWORD=user42
ENV HOSTNAME=localhost

# Install necessary packages
RUN apk add --no-cache mysql mysql-client

# Create mysqld app dir
RUN mkdir -p /run/mysqld \
 && chown -R mysql:mysql /run/mysqld

# Where MySQL by default will write its data files
VOLUME ["/var/lib/mysql"]

# Inform which ports are intended to be published
EXPOSE 3306

# Copy init script
COPY config/init_db.sh /root/

ENTRYPOINT ["sh", "/root/init_db.sh"]
