FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV INFLUXDB_VERSION=1.8.3-r2
ENV INFLUXDB_CONFIG_PATH=/etc/influxdb/influxdb.conf
ENV INFLUXDB_DATA_DIR=/var/lib/influxdb/data
ENV INFLUXDB_LOG_DIR=/var/log/influxdb

# Install necessary packages
RUN apk update \
 && apk add --no-cache influxdb=${INFLUXDB_VERSION}

# Create InfluxDB directories and move config files
RUN mkdir -p "/etc/influxdb/" $INFLUXDB_DATA_DIR $INFLUXDB_LOG_DIR \
 && mv /etc/influxdb.conf $INFLUXDB_CONFIG_PATH

#RUN influxd run -pidfile=/var/log/influxdb/influxd.log &

# Inform which ports are intended to be published
EXPOSE 8086
