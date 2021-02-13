#!/bin/sh
#
# Setup

TAG=1.0

# Start cluster
minikube start --vm-driver=docker

# Enable dashboard
minikube addons enable dashboard

# Build images
docker build -t nginx:$TAG srcs/nginx
docker build -t wordpress:$TAG srcs/wordpress

# Secrets
#kubectl apply -f ./secrets/wordpress-db.yaml

# Create namespace
#kubectl create -f ./srcs/ft-services.yaml
