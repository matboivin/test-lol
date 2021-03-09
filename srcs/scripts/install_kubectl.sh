#!/bin/zsh
#
# Ensure kubectl is installed

# VARIABLES
KUBECTL_VERSION=v1.20.2
BIN_PATH=/usr/local/bin

# Install kubectl if the version is not the one expected
if ! [[ $(kubectl version) =~ "$KUBECTL_VERSION" ]] || [ $? -eq 127 ]; then
    # Check directory exists
    if [ ! -d "$BIN_PATH" ]; then
        mkdir -p $BIN_PATH
    fi
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
    echo "😄  kubectl $KUBECTL_VERSION is installed"
fi

exit 0
