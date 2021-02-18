#!/bin/zsh
#
# Clean ft_services project at 42

minikube delete
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
