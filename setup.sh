#!/bin/zsh
#
# Setup ft_services project at 42

# VARIABLES
DEPLOY_PATH=srcs/deployments

echo "START FT_SERVICES\n"

# INSTALL
echo "STEP 1/4 Install\n"
zsh install.sh

# START MINIKUBE
echo "\nSTEP 2/4 Start minikube\n"

# Start cluster
echo "⧗   Start the cluster ...\n"
minikube start --driver=docker
# Configure environment to use minikube’s Docker daemon
eval $(minikube docker-env)
# Necessary addons
minikube addons enable metrics-server
minikube addons enable dashboard
minikube addons enable metallb

# DOCKER IMAGES
echo "\nSTEP 3/4 Build docker images\n"
zsh build_docker.sh

# CLUSTER
echo "\nSTEP 4/4 Configure cluster\n"
kubectl apply -f srcs --recursive

#minikube dashboard
