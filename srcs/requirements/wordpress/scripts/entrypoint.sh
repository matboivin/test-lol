#!/bin/sh
#
# Docker entrypoint

# Exit immediately if a command exits with a non-zero status
set -e

sed --in-place 's/__DB_NAME__/'$WORDPRESS_DB_NAME'/g' /var/www/wordpress/wp-config.php
sed --in-place 's/__DB_USER__/'$WORDPRESS_DB_USER'/g' /var/www/wordpress/wp-config.php
sed --in-place 's/__DB_PASSWORD__/'$WORDPRESS_DB_PASSWORD'/g' /var/www/wordpress/wp-config.php
sed --in-place 's/__DB_HOST__/'$WORDPRESS_DB_HOST'/g' /var/www/wordpress/wp-config.php
sed --in-place 's/__DB_PORT__/'$WORDPRESS_DB_PORT'/g' /var/www/wordpress/wp-config.php

exec "$@"
