#!/bin/sh
# Setup

# Add user42 to the Docker group
#sudo usermod -aG docker $(whoami)
# Apply changes
#su $(whoami)

# Start cluster
minikube start --vm-driver=docker

#minikube dashboard
