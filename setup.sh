#!/bin/sh
#
# Setup

# Start cluster
minikube start --vm-driver=docker

# Enable dashboard
minikube addons enable dashboard
