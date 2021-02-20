#!/bin/zsh
#
# Setup ft_services project at 42

# VARIABLES
MANIFESTS_PATH=srcs
SCRIPTS_PATH=srcs/scripts

echo "START FT_SERVICES\n"

# INSTALL
echo "STEP 1/4 Launch minikube\n"
zsh $SCRIPTS_PATH/install_minikube.sh

# Start cluster
echo "⧗   Start the cluster ...\n"
minikube start --driver=docker
# Configure environment to use minikube’s Docker daemon
eval $(minikube docker-env)
# Check kubectl version
zsh $SCRIPTS_PATH/install_kubectl.sh

# Necessary addons
minikube addons enable metrics-server
minikube addons enable dashboard
minikube addons enable metallb

# DOCKER IMAGES
echo "\nSTEP 2/4 Build docker images\n"
zsh $SCRIPTS_PATH/build_docker.sh

# CLUSTER
echo "\nSTEP 3/4 Configure cluster\n"
kubectl apply -f $MANIFESTS_PATH/00-namespace.yaml
kubectl apply -f $MANIFESTS_PATH --recursive

#minikube dashboard
