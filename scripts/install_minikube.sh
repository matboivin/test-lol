#!/bin/zsh
#
# Ensure minikube is installed

# VARIABLES
MINIKUBE_VERSION=v1.18.1
BIN_PATH=/usr/local/bin

# Install minikube if the version is not the one expected
if ! [[ $(minikube version) =~ "$MINIKUBE_VERSION" ]] || [ $? -eq 127 ]; then
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
    echo "😄  minikube $MINIKUBE_VERSION is installed"
fi

exit 0
