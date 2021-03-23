#!/bin/sh
#
# Docker entrypoint

# Exit immediately if a command exits with a non-zero status
set -e

# Replace parameters in config
sed --in-place 's/__MYSQL_USER__/'$MYSQL_USER'/g' /var/www/phpmyadmin/config.inc.php
sed --in-place 's/__MYSQL_PASSWORD__/'$MYSQL_PASSWORD'/g' /var/www/phpmyadmin/config.inc.php
sed --in-place 's/__MYSQL_DB__/'$MYSQL_DATABASE'/g' /var/www/phpmyadmin/config.inc.php
sed --in-place 's/__PMA_HOST__/'$PMA_HOST'/g' /var/www/phpmyadmin/config.inc.php
sed --in-place 's/__PMA_PORT__/'$PMA_PORT'/g' /var/www/phpmyadmin/config.inc.php

exec "$@"
