FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_USER user42
ENV MYSQL_PASSWORD user42
ENV MYSQL_DATABASE test

# Install necessary packages
RUN apk add --no-cache mysql mysql-client

# Init database
#COPY config/init_db.sh /scripts/
#RUN sh scripts/init_db.sh

# Inform which ports are intended to be published
EXPOSE 3306
