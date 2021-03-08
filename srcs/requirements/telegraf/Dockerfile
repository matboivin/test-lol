FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV TELEGRAF_VERSION=1.17.0-r0
ENV TELEGRAF_CONFIG_PATH=/etc/telegraf/telegraf.conf

# Install necessary packages
RUN apk update \
 && apk add --no-cache telegraf=${TELEGRAF_VERSION} \
 && mkdir -p /root/scripts

# Add necessary scripts
COPY scripts/ /root/scripts/

# Create Telegraf directories and backup default conf
RUN mkdir -p /etc/telegraf \
 && mv -f /etc/telegraf.conf.d /etc/telegraf/ \
 && mv /etc/telegraf.conf $TELEGRAF_CONFIG_PATH

# Inform which ports are intended to be published
EXPOSE 8125/udp

ENTRYPOINT ["sh", "/root/scripts/entrypoint.sh"]
CMD ["/usr/bin/telegraf ", "--config $TELEGRAF_CONFIG_PATH"]
