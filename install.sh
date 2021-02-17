#!/bin/sh
#
# Install minikube and kubectl

# VARIABLES
MINIKUBE_VERSION=v1.17.1
KUBECTL_VERSION=v1.18.0

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
