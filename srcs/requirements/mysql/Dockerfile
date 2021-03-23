FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV MYSQL_VERSION=10.5.8-r0

# Install necessary packages
RUN apk update \
 && apk add --no-cache mysql=${MYSQL_VERSION} mysql-client=${MYSQL_VERSION} \
 && mkdir -p /etc/mysql/ /var/log/mysql \
 && chown -R mysql:mysql /etc/mysql/ /var/log/mysql

# Add necessary scripts
COPY scripts/ /opt/

# Copy basic config
COPY config/my.cnf /etc/my.cnf

# Where MySQL by default will write its data files
VOLUME ["/var/lib/mysql"]

# Inform which ports are intended to be published
EXPOSE 3306

ENTRYPOINT ["sh", "/opt/entrypoint.sh"]
CMD ["/usr/bin/mysqld", "--user=root", "--console"]
