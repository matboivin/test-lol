#!/bin/sh
#
# Setup database

# Tmp file to create WordPress database
tmp_file=mysql_conf

cat << EOF > $tmp_file
CREATE DATABASE $MYSQL_DATABASE;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'$HOSTNAME' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
EOF

# Install MariaDB/MySQL in /var/lib/mysql
mysql_install_db --user=mysql --datadir=/var/lib/mysql #> /dev/null
sleep 5

# Start mysqld in background
#/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &
#sleep 6
#mysql -e "$(cat $tmp_file)"
#rm -rf $tmp_file

/usr/bin/mysqld --user=mysql < $tmp_file
