#!/bin/sh
#
# Setup

MINIKUBE_VERSION=v1.17.1
KUBECTL_VERSION=v1.18.0
IMAGES_TAG=1.0
DOCKERFILE_PATH=docker-config

# Check directory exists
if [ ! -d "/usr/local/bin/r" ]; then
    mkdir -p /usr/local/bin/
fi

# Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-linux-amd64
chmod +x minikube
sudo install minikube /usr/local/bin/

if [ $? -eq 0 ]; then
    echo "√  minikube was installed"
    rm -rf minikube
else
    echo "✘  minikube installation failed"
    exit 1
fi

# Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
&& chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

if [ $? -eq 0 ]; then
    echo "√  kubectl was installed"
else
    echo "✘  kubectl installation failed"
    exit 1
fi

# Start cluster
minikube start --vm-driver=docker

# Enable dashboard
minikube addons enable dashboard
# Enable MetalLB load balancer
minikube addons enable metallb

# Build images
docker build -t nginx:$IMAGES_TAG $DOCKERFILE_PATH/nginx
docker build -t wordpress:$IMAGES_TAG $DOCKERFILE_PATH/wordpress

# Secrets
#kubectl apply -f ./secrets/wordpress-db.yaml

# Create namespace
#kubectl create -f ./srcs/ft-services.yaml
