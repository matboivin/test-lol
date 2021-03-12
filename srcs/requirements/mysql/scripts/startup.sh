#!/bin/sh
#
# Docker startup

# Data dir
if [ ! -d /var/lib/mysql/mysql ]; then
	# Install MariaDB/MySQL in /var/lib/mysql
	echo "⧗   Install MariaDB/MySQL system tables in '/var/lib/mysql' ..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
	sleep 4

	# Start mysqld in background
	echo "⧗   Start mysqld in background ..."
	mysqld_safe --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid &
	sleep 2

	# Create database
	echo "⧗   Create database ..."
	mysql -e "CREATE DATABASE $MYSQL_DATABASE;GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'$HOSTNAME' IDENTIFIED BY '$MYSQL_PASSWORD';FLUSH PRIVILEGES;"
	# Kill mysqld
	kill `cat /run/mysqld/mysqld.pid`
	sleep 2
fi

# App state dir
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# Logging dir
if [ ! -d "/var/log/mysql" ]; then
	mkdir -p /var/log/mysql
	chown -R mysql:mysql /var/log/mysql
fi

chown -R mysql:mysql /var/lib/mysql

echo "√   Done"
