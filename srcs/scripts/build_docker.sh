#!/bin/zsh
#
# Build Docker images

# VARIABLES
IMAGES_TAG=ft
DOCKERFILE_PATH=../srcs/requirements

echo "\n⧗   Build docker images\n"
eval $(minikube docker-env)

docker build -t mariadb:$IMAGES_TAG $DOCKERFILE_PATH/mariadb
echo "\n√   MariaDB image was successfully built\n"

docker build -t phpmyadmin:$IMAGES_TAG $DOCKERFILE_PATH/phpmyadmin
echo "\n√   PhpMyAdmin image was successfully built\n"

docker build -t wordpress:$IMAGES_TAG $DOCKERFILE_PATH/wordpress
echo "\n√   WordPress image was successfully built\n"

docker build -t nginx:$IMAGES_TAG $DOCKERFILE_PATH/nginx
echo "\n√   NGINX image was successfully built\n"

docker build -t vsftpd:$IMAGES_TAG $DOCKERFILE_PATH/vsftpd
echo "\n√   vsftpd server image was successfully built\n"

docker build -t influxdb:$IMAGES_TAG $DOCKERFILE_PATH/influxdb
echo "\n√   InfluxDB image was successfully built\n"

docker build -t telegraf:$IMAGES_TAG $DOCKERFILE_PATH/telegraf
echo "\n√   Telegraf image was successfully built\n"

docker build -t grafana:$IMAGES_TAG $DOCKERFILE_PATH/grafana
echo "\n√   Grafana image was successfully built\n"
