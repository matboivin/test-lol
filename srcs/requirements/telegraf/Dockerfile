FROM alpine:3.13

LABEL maintainer="mboivin@student.42.fr"

# Environment Variables
ENV TELEGRAF_VERSION=1.17.0-r0
ENV TELEGRAF_CONFIG_PATH=/etc/telegraf/telegraf.conf

# Install necessary packages
RUN apk update \
 && apk add --no-cache telegraf=${TELEGRAF_VERSION}

# Add necessary scripts
COPY scripts/ /opt/

# Create Telegraf directories and backup default conf
RUN mkdir -p /etc/telegraf \
 && mv -f /etc/telegraf.conf.d /etc/telegraf/ \
 && mv /etc/telegraf.conf /etc/telegraf/telegraf.conf.default

# Inform which ports are intended to be published
EXPOSE 8125/udp

ENTRYPOINT ["sh", "/opt/entrypoint.sh"]
CMD ["telegraf"]
