#!/bin/zsh
#
# Build Docker images

# VARIABLES
IMAGES_TAG=dev
DOCKERFILE_PATH=srcs/docker-config

docker build -t nginx:$IMAGES_TAG $DOCKERFILE_PATH/nginx
echo "\n√   NGINX image was successfully built\n"

docker build -t mysql:$IMAGES_TAG $DOCKERFILE_PATH/mysql
echo "\n√   MySQL image was successfully built\n"

docker build -t phpmyadmin:$IMAGES_TAG $DOCKERFILE_PATH/phpmyadmin
echo "\n√   PhpMyAdmin image was successfully built\n"

docker build -t wordpress:$IMAGES_TAG $DOCKERFILE_PATH/wordpress
echo "\n√   WordPress image was successfully built\n"
