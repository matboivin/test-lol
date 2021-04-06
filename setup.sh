#!/bin/zsh
#
# Setup ft_services project at 42

# VARIABLES
KUBECTL_VERSION=v1.20.2
IMAGES_TAG=ft
DOCKERFILE_PATH=requirements
MANIFESTS_PATH=manifests
SCRIPTS_PATH=scripts
PROJECT_NAMESPACE=ft-services

echo "⧗   START FT_SERVICES\n"

# INSTALL
echo "⧗   1/4 Launch minikube\n"
zsh $SCRIPTS_PATH/install_minikube.sh
# Clean existing cluster
minikube delete

# Start cluster
echo "\n⧗   2/4 Start the cluster ...\n"
minikube start --driver=docker --kubernetes-version=$KUBECTL_VERSION
# Check kubectl version
zsh $SCRIPTS_PATH/install_kubectl.sh

# Necessary addons
minikube addons enable metrics-server
minikube addons enable dashboard
minikube addons enable metallb

# Configure environment to use minikube’s Docker daemon
eval $(minikube docker-env)

# DOCKER IMAGES
echo "\n⧗   3/4 Build docker images\n"

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

# CONFIGURE CLUSTER
echo "⧗   4/4Configure cluster\n"
# Replace single IP in MetalLB config
KUBERNETES_HOST=$(minikube ip)
# Equivalent:
#KUBERNETES_HOST=$(shell kubectl get node minikube -o jsonpath='{.status.addresses[0].address}')
sed --in-place 's/__IP__/'$KUBERNETES_HOST'/g' $MANIFESTS_PATH/configmaps/metallb-cm.yaml
# Create resources
kubectl apply -f $MANIFESTS_PATH/00-namespace.yaml
kubectl apply -f $MANIFESTS_PATH/secrets
kubectl apply -f $MANIFESTS_PATH/configmaps --recursive
kubectl apply -f $MANIFESTS_PATH/statefulsets
kubectl apply -f $MANIFESTS_PATH/deployments
kubectl apply -f $MANIFESTS_PATH/daemonsets
# Set context to use ft-services as permanent namespace
kubectl config set-context --current --namespace=$PROJECT_NAMESPACE

echo "\n⧗   ...\n"
sleep 4

# PRINT INFORMATIONS
echo "\n√   SETUP DONE\n\n    IP: $KUBERNETES_HOST"
echo "\n    Ports:\n    - PMAPORT: 5000\n    - WPPORT: 5050\n    - GRAFANAPORT: 3000"

# Launch dashboard
echo "    To open Kubernetes dashboard, click on the URL below and select the 'ft-services' namespace.\n"
minikube dashboard --url
