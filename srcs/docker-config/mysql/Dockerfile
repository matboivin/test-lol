FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV MYSQL_DATABASE=wordpress-db
ENV MYSQL_USER=user42
ENV MYSQL_PASSWORD=user42
ENV HOSTNAME=localhost

# Install necessary packages
RUN apk add --no-cache mysql mysql-client openrc

# Init database
RUN mkdir -p /scripts/ \
 && mkdir -p /run/mysqld \
 && chown -R mysql:mysql /run/mysqld \
 && mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
#COPY config/setup_db.sh /scripts/
COPY config/mysql_conf /scripts/

# Where MySQL by default will write its data files
VOLUME ["/var/lib/mysql"]

# Inform which ports are intended to be published
EXPOSE 3306
