#!/bin/zsh
#
# Build Docker images

# VARIABLES
IMAGES_TAG=dev
DOCKERFILE_PATH=srcs/docker-config

docker build -t nginx:$IMAGES_TAG $DOCKERFILE_PATH/nginx
echo "\n√   NGINX image was successfully built\n"

docker build -t wordpress:$IMAGES_TAG $DOCKERFILE_PATH/wordpress
echo "\n√   WordPress image was successfully built\n"
