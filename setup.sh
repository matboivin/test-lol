#!/bin/sh
#
# Launch ft_services project at 42

# VARIABLES
MINIKUBE_VERSION=v1.17.1
KUBECTL_VERSION=v1.18.0
IMAGES_TAG=1.0
DOCKERFILE_PATH=srcs/docker-config
DEPLOY_PATH=srcs/deployments

echo "START FT_SERVICES\n"

# INSTALL
echo "STEP 1/5 Install\n"

# Check directory exists
if [ ! -d "/usr/local/bin/r" ]; then
    mkdir -p /usr/local/bin/
fi

# Get minikube and kubectl
echo "⧗   Downloading minikube with curl ...\n"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-linux-amd64
echo "\n⧗   Downloading kubectl with curl ...\n"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl

# Install minikube
chmod +x minikube \
&& sudo install minikube /usr/local/bin/

if [ $? -eq 0 ]; then
    echo "\n√   minikube was installed"
    rm -rf minikube
else
    echo "\n✘   minikube installation failed"
    exit 1
fi

# Install kubectl
chmod +x ./kubectl \
&& sudo mv ./kubectl /usr/local/bin/kubectl

if [ $? -eq 0 ]; then
    echo "√   kubectl was installed"
else
    echo "✘   kubectl installation failed"
    exit 1
fi

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

docker build -t nginx:$IMAGES_TAG $DOCKERFILE_PATH/nginx
docker build -t wordpress:$IMAGES_TAG $DOCKERFILE_PATH/wordpress

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
