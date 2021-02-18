#!/bin/zsh
#
# Setup ft_services project at 42

# VARIABLES
DEPLOY_PATH=srcs/deployments

echo "START FT_SERVICES\n"

# INSTALL
echo "STEP 1/5 Install\n"
zsh install.sh

# START MINIKUBE
echo "\nSTEP 2/5 Start minikube\n"

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
echo "\nSTEP 3/5 Build docker images\n"
zsh build_docker.sh

# LOAD BALANCER
echo "\nSTEP 4/5 Configure load balancer\n"

# MetalLB configuration
kubectl apply -f srcs/metallb-config.yaml

# DEPLOYMENT
echo "\nSTEP 4/5 Deploy\n"

# Secrets
#kubectl apply -f ./secrets/wordpress-db.yaml

# Create namespace
#kubectl create -f ./srcs/ft-services.yaml

# Deployments
kubectl apply -f $DEPLOY_PATH/nginx-deployment.yaml

#minikube dashboard
