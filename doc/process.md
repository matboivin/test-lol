# Process

Kubernetes cluster composed of:
- a LEMP stack + PMA + WordPress
- a TIG stack
- a FTP server

**Table of Contents**

1. [Installation](#installation)
2. [Start cluster](#start-cluster)
3. [Containerize apps](#containerize-apps)
4. [Load balancer](#load-balancer)

## Installation

#### Requirements

- 2 CPUs or more
- 2GB of free memory
- 20GB of free disk space
- Internet connection
- Container or virtual machine manager, such as: Docker, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, or VMWare

Source: [minikube start](https://minikube.sigs.k8s.io/docs/start/)

Add `user42` to the docker group:

```console
sudo usermod -aG docker $(whoami)
su $(whoami)

# Will also maybe require
sudo systemctl restart docker
```

Install [jq](https://stedolan.github.io/jq/) to format output:

```console
kubectl version -o json | jq
```

## Start cluster

- [Kubernetes Documentation: Pick up the right solution](https://kubernetes.io/fr/docs/setup/pick-right-solution/)
- [Kubernetes Documentation: Install tools](https://kubernetes.io/docs/tasks/tools/)

> Minikube est la solution adaptée pour les petits projets basés sur les conteneurs. Par exemple, quand on souhaite mettre en place un cluster Kubernetes privé, il n’est plus nécessaire de travailler avec un serveur complet ou sur le cloud. Minikube se passe de grandes infrastructures et peut facilement déployer des clusters locaux.  
Un ordinateur et un cluster avec un seul nœud : c’est tout ce dont Minikube a besoin. Ces prérequis minimaux s’adressent en premier lieu aux petits projets privés de développeurs, qui peuvent déployer leurs créations très simplement grâce à Minikube. Il n’y a besoin ni de serveur, ni de cloud : le cluster Kubernetes s’exécute uniquement sur l’hôte local. Minikube fonctionne par défaut avec une VirtualBox, qui sert de VM d’environnement d’exécution.

Source: [Minikube : un environnement Kubernetes maximal pour une charge de travail allégée](https://www.ionos.fr/digitalguide/serveur/outils/minikube-de-kubernetes/)

**TL;DR** Minikube runs a single node cluster in a VM for a local usage on your laptop.

Some dashboard features require the metrics-server addon. To enable all features please run:

```console
minikube addons enable metrics-server
```

## Containerize apps

#### Requirements

- [X] Data persistence
- [X] Restart in case of crash
- [X] No NodePort
- [Write Dockerfiles](containers.md)

type: `LoadBalancer` -> exposes the service externally using a load balancer  
type: `ClusterIP` -> the service is accessible within the cluster, not meant for external access

## Load balancer

#### Requirements

- [X] Redirection
- [X] No Ingress
- [X] No `kubectl port-forward`

#### Resources

- [MetalLB documentation: MetalLB installation](https://metallb.universe.tf/installation/)
- [MetalLB documentation: IP address sharing](https://metallb.universe.tf/usage/#ip-address-sharing)
- [Getting external traffic into Kubernetes – ClusterIp, NodePort, LoadBalancer, and Ingress](https://www.ovh.com/blog/getting-external-traffic-into-kubernetes-clusterip-nodeport-loadbalancer-and-ingress/)
- [MetalLB (Network LoadBalancer ) & Minikube.](https://medium.com/@shoaib_masood/metallb-network-loadbalancer-minikube-335d846dfdbe)

**TL;DR** MetalLB is a bare metal load balancer. Its role is to distribute the requests between services of our cluster, depending on the ability of these services to fulfill requests. It ensures no service becomes overworked, reduces incidents and minimizes response time.
