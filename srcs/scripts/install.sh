#!/bin/zsh
#
# Install minikube and kubectl

# VARIABLES
MINIKUBE_VERSION=v1.17.1
KUBECTL_VERSION=v1.18.0
BIN_PATH=/usr/local/bin

# Check directory exists
if [ ! -d "$BIN_PATH" ]; then
    mkdir -p $BIN_PATH
fi

# Install minikube
if ! [[ $(minikube version) =~ "$MINIKUBE_VERSION" ]]; then
    sudo rm -rf $BIN_PATH/minikube
    echo "⧗   Downloading minikube with curl ...\n"
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/$MINIKUBE_VERSION/minikube-linux-amd64
    chmod +x minikube && sudo install minikube $BIN_PATH
    if [ $? -eq 0 ]; then
        echo "\n√   minikube $MINIKUBE_VERSION was installed"
        rm -rf minikube
    else
        echo "\n✘   minikube installation failed"
        exit 1
    fi
else
    echo "😄   minikube $MINIKUBE_VERSION is installed"
fi

# Install kubectl
if ! [[ $(kubectl version) =~ "$KUBECTL_VERSION" ]]; then
    sudo rm -rf $BIN_PATH/kubectl
    echo "\n⧗   Downloading kubectl with curl ...\n"
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl
    chmod +x ./kubectl && sudo mv ./kubectl $BIN_PATH/kubectl
    if [ $? -eq 0 ]; then
        echo "√   kubectl $KUBECTL_VERSION was installed"
    else
        echo "✘   kubectl installation failed"
        exit 1
    fi
else
    echo "😄   kubectl $KUBECTL_VERSION is installed"
fi

exit 0
