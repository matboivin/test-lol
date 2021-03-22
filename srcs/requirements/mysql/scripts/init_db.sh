#!/bin/sh
#
# Init database

TMP_FILE=tmp_init.sql

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

	cat << EOF > $TMP_FILE
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
ALTER USER 'root'@'localhost' IDENTIFIED BY '';

CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

	mysql -u root < $TMP_FILE
	rm $TMP_FILE
	# Kill mysqld
	kill `cat /run/mysqld/mysqld.pid`
	sleep 2
fi

chown -R mysql:mysql /var/lib/mysql

echo "√   Done"
