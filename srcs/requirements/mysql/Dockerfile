FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV MARIADB_VERSION=10.5.8-r0
ENV MYSQL_DATABASE=wordpress_db
ENV MYSQL_USER=user42
ENV MYSQL_PASSWORD=user42
ENV HOSTNAME=localhost

# Install necessary packages
RUN apk update \
 && apk add --no-cache mariadb=${MARIADB_VERSION} mariadb-client=${MARIADB_VERSION}

# Create mysqld app dir
RUN mkdir -p /run/mysqld /var/lib/mysql/mysql \
 && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy basic config
COPY config/my.cnf /etc/my.cnf

# Where MySQL by default will write its data files
VOLUME ["/var/lib/mysql"]

# Inform which ports are intended to be published
EXPOSE 3306

# Copy init script
COPY init_mysql_db.sh /root/
RUN sh /root/init_mysql_db.sh

COPY entrypoint.sh /entrypoint.sh
#ENTRYPOINT ["sh", "/entrypoint.sh"]
