#!/bin/sh
#
# Init database

if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Install MariaDB/MySQL in /var/lib/mysql
    echo "⧗   Install MariaDB/MySQL system tables in '/var/lib/mysql' ..."
    mysql_install_db --user=root --datadir=/var/lib/mysql > /dev/null

    if [ ! -d "/run/mysqld" ]; then
      mkdir -p /run/mysqld
    fi

    # Start mysqld in background
    echo "⧗   Start mysqld ..."
    /usr/bin/mysqld --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid &
    sleep 2

    # Create database
    echo "⧗   Create database ..."
    cat << EOF > /opt/init.sql
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' WITH GRANT OPTION;
EOF

    mysql --user=root --password="$MYSQL_ROOT_PASSWORD" < /opt/init.sql
    mysql --user=root --password="$MYSQL_ROOT_PASSWORD" $MYSQL_DATABASE < /opt/wordpress.sql
    # Kill mysqld
    kill  `cat /run/mysqld/mysqld.pid`
    rm -f /opt/init.sql /opt/wordpress.sql
fi

chown -R mysql:mysql /var/lib/mysql
echo "√   Done"
