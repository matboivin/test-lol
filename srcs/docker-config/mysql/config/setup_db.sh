#!/bin/sh
#
# Setup database

# Install MariaDB/MySQL in /var/lib/mysql
mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

# Create database
cat << EOF > mysql_conf
GRANT ALL PRIVILEGES ON *.* TO 'root'@'$HOSTNAME' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT SELECT, SHOW VIEW, PROCESS ON *.* TO '$MYSQL_USER'@'$HOSTNAME' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;

CREATE DATABASE $MYSQL_DATABASE;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'$HOSTNAME' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
EOF

#/usr/bin/mysqld --user=mysql < mysql_conf
