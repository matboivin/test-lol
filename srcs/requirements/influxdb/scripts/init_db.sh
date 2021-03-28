#!/bin/sh
#
# Init database

# Start influxd in background
echo "⧗   Start influxd ..."
mkdir -p /var/run/influxd
influxd run -pidfile "/var/run/influxd/influxd.pid" &
sleep 2

# Create database
echo "⧗   Create database ..."
influx -execute "CREATE DATABASE $INFLUXDB_DB"
influx -execute "CREATE USER $INFLUXDB_USER WITH PASSWORD '$INFLUXDB_PASS'"
influx -execute "GRANT ALL ON $INFLUXDB_DB TO $INFLUXDB_USER"
influx -execute "USE $INFLUXDB_DB"

# Kill influxd
kill `cat /var/run/influxd/influxd.pid`
echo "√   Done"
