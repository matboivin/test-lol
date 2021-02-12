#!/bin/sh
#
# Setup

# Start cluster
minikube start --vm-driver=docker

# Enable dashboard
minikube addons enable dashboard

# Build images
docker build -t nginx srcs/nginx
docker build -t wordpress srcs/wordpress

# Create namespace
kubectl create -f ./srcs/ft-services-namespace.yaml
