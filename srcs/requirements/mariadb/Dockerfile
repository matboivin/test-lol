FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV MARIADB_VERSION=10.5.9-r0

# Install necessary packages
RUN apk update \
 && apk add --no-cache mariadb=${MARIADB_VERSION} mariadb-client=${MARIADB_VERSION} \
 && mkdir -p /etc/mysql/ /var/log/mysql /run/mysqld \
 && chown -R mysql:mysql /etc/mysql/ /var/log/mysql

# Add necessary scripts
COPY scripts/ /opt/

# Add WordPress database
COPY db/wordpress.sql /opt/

# Data directory
VOLUME ["/var/lib/mysql"]

# Inform which ports are intended to be published
EXPOSE 3306

ENTRYPOINT ["sh", "/opt/docker_entrypoint.sh"]
CMD ["/usr/bin/mysqld", "--user=root"]
