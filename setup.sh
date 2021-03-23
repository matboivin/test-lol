#!/bin/zsh
#
# Setup ft_services project at 42

# VARIABLES
MANIFESTS_PATH=srcs/manifests
SCRIPTS_PATH=srcs/scripts
PROJECT_NAMESPACE=ft-services

echo "⧗   START FT_SERVICES\n"

# INSTALL
echo "⧗   Launch minikube\n"
zsh $SCRIPTS_PATH/install_minikube.sh
# Clean existing cluster
minikube delete

# Start cluster
echo "\n⧗   Start the cluster ...\n"
minikube start --driver=docker --kubernetes-version v1.20.2
MINIKUBE_IP="$(minikube ip)"
# Configure environment to use minikube’s Docker daemon
eval $(minikube docker-env)
# Check kubectl version
zsh $SCRIPTS_PATH/install_kubectl.sh

# Necessary addons
minikube addons enable metrics-server
minikube addons enable dashboard
minikube addons enable metallb

# DOCKER IMAGES
echo "\n⧗   Build docker images\n"
zsh $SCRIPTS_PATH/build_docker.sh

# CONFIGURE CLUSTER
echo "⧗   Configure cluster\n"
# Replace single IP in MetalLB config
sed --in-place 's/__IP__/'$MINIKUBE_IP'/g' $MANIFESTS_PATH/configmaps/metallb-config.yaml
# Creates resources
kubectl apply -f $MANIFESTS_PATH/00-namespace.yaml
kubectl apply -f $MANIFESTS_PATH/secrets --recursive
kubectl apply -f $MANIFESTS_PATH/configmaps --recursive
kubectl apply -f $MANIFESTS_PATH/services --recursive
# Set context to use ft-services as permanent namespace
kubectl config set-context --current --namespace=$PROJECT_NAMESPACE

# PRINT INFORMATIONS
echo "\n√   DONE\n\n    IP is: $MINIKUBE_IP"
echo "\n    For WordPress and phpMyAdmin:"
echo "    - User: user42\n    - Password: user42"

#minikube dashboard
