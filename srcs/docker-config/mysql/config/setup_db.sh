#!/bin/sh
#
# Setup database

# Start service
service mysql start

# Create database user
mysql -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD'"

# phpMyAdmin database
mysql -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO '$MYSQL_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# WordPress database
mysql -e "CREATE DATABASE $MYSQL_DATABASE;"
mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

mysql $MYSQL_DATABASE -u root < /root/wordpress_db.sql
rm /root/wordpress_db.sql
