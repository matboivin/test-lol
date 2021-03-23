#!/bin/sh
#
# Init database

TMP_FILE=tmp_init

if [ ! -d "/var/lib/mysql/mysql" ]; then
  # Install MariaDB/MySQL in /var/lib/mysql
  echo "⧗   Install MariaDB/MySQL system tables in '/var/lib/mysql' ..."
  mysql_install_db --user=root --datadir=/var/lib/mysql > /dev/null

  if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
  fi

  # Create database
  echo "⧗   Create database ..."
  cat << EOF > $TMP_FILE
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' WITH GRANT OPTION;
EOF

  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < $TMP_FILE
  rm -f $TMP_FILE
fi

chown -R mysql:mysql /var/lib/mysql
echo "√   Done"
