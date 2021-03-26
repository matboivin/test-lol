FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV INFLUXDB_VERSION=1.8.3-r2
ENV INFLUXDB_CONFIG_PATH=/etc/influxdb/influxdb.conf
ENV INFLUXDB_DATA_DIR=/var/lib/influxdb/data
ENV INFLUXDB_DATA_WAL_DIR=/var/lib/influxdb/wal
ENV INFLUXDB_LOG_DIR=/var/log/influxdb

# Install necessary packages
RUN apk update \
 && apk add --no-cache influxdb=${INFLUXDB_VERSION}

# Add necessary scripts
COPY scripts/ /opt/

# Create InfluxDB directories and backup default conf
RUN mkdir -p /etc/influxdb $INFLUXDB_DATA_DIR $INFLUXDB_DATA_WAL_DIR $INFLUXDB_LOG_DIR \
 && mv /etc/influxdb.conf $INFLUXDB_CONFIG_PATH

VOLUME ["/var/lib/influxdb"]

# Inform which ports are intended to be published
EXPOSE 8086

ENTRYPOINT ["sh", "/opt/entrypoint.sh"]
CMD ["influxd"]
