#!/bin/sh
#
# Setup database

# Create database user
mysql -e "CREATE USER '$MYSQL_USER'@'$HOSTNAME' IDENTIFIED BY '$MYSQL_PASSWORD'"

# phpMyAdmin database
mysql -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO '$MYSQL_USER'@'$HOSTNAME';"
mysql -e "FLUSH PRIVILEGES;"

# WordPress database
mysql -e "CREATE DATABASE $MYSQL_DATABASE;"
mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'$HOSTNAME';"
mysql -e "FLUSH PRIVILEGES;"
