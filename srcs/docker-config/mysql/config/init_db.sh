#!/bin/sh
#
# Init database

# Install MariaDB/MySQL in /var/lib/mysql
echo "⧗   Install MariaDB/MySQL system tables in '/var/lib/mysql' ..."
mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
sleep 5

# Start mysqld in background
echo "⧗   Start mysqld in background ..."
/usr/bin/mysqld_safe --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid &
sleep 5

# Create database
echo "⧗   Create database ..."
mysql -e "CREATE DATABASE $MYSQL_DATABASE;GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'$HOSTNAME' IDENTIFIED BY '$MYSQL_PASSWORD';FLUSH PRIVILEGES;"
# Kill mysqld
kill `cat /run/mysqld/mysqld.pid`
sleep 5
# Restart mysqld
echo "√   Done"
/usr/bin/mysqld_safe --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid
