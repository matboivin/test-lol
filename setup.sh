#!/bin/sh
#
# Setup

TAG=1.0

# Start cluster
minikube start --vm-driver=docker

# Enable dashboard
minikube addons enable dashboard

# Enable strict ARP mode for MetalLB
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

# To install MetalLB, apply the manifest
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
# On first install only
#kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# Build images
docker build -t nginx:$TAG srcs/nginx
docker build -t wordpress:$TAG srcs/wordpress

# Secrets
#kubectl apply -f ./secrets/wordpress-db.yaml

# Create namespace
#kubectl create -f ./srcs/ft-services.yaml
