#!/bin/sh
#
# Setup database

# Install MariaDB/MySQL in /var/lib/mysql
mysql_install_db --user=mysql --datadir=/var/lib/mysql # > /dev/null
# Start mysqld in background
/usr/bin/mysqld_safe --datadir='/var/lib/mysql'&

# Create WordPress database
cat << EOF > mysql_conf
CREATE DATABASE $MYSQL_DATABASE;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'$HOSTNAME' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
EXIT
EOF

#mysql -u root password $MYSQL_ROOT_PASSWORD < mysql_conf
#/usr/bin/mysqld --user=mysql
