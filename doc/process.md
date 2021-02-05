# Process

LEMP stack infrastructure in a kubernetes cluster.

## Steps

### Installation

42VM requires 2 CPU.  
Add user42 to the docker group:

```console
sudo usermod -aG docker $(whoami)
su $(whoami)

# Will also maybe require
sudo systemctl restart docker
```

- [Kubernetes Documentation: Pick up the right solution](https://kubernetes.io/fr/docs/setup/pick-right-solution/)
- [Kubernetes Documentation: Install tools](https://kubernetes.io/docs/tasks/tools/)

> Minikube est la solution adaptée pour les petits projets basés sur les conteneurs. Par exemple, quand on souhaite mettre en place un cluster Kubernetes privé, il n’est plus nécessaire de travailler avec un serveur complet ou sur le cloud. Minikube se passe de grandes infrastructures et peut facilement déployer des clusters locaux.  
Un ordinateur et un cluster avec un seul nœud : c’est tout ce dont Minikube a besoin. Ces prérequis minimaux s’adressent en premier lieu aux petits projets privés de développeurs, qui peuvent déployer leurs créations très simplement grâce à Minikube. Il n’y a besoin ni de serveur, ni de cloud : le cluster Kubernetes s’exécute uniquement sur l’hôte local. Minikube fonctionne par défaut avec une VirtualBox, qui sert de VM d’environnement d’exécution.

Source: [Minikube : un environnement Kubernetes maximal pour une charge de travail allégée](https://www.ionos.fr/digitalguide/serveur/outils/minikube-de-kubernetes/)

- 2 CPUs or more
- 2GB of free memory
- 20GB of free disk space
- Internet connection
- Container or virtual machine manager, such as: Docker, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, or VMWare

Source: [minikube start](https://minikube.sigs.k8s.io/docs/start/)

Install [jq](https://stedolan.github.io/jq/) to format output:

```console
kubectl version -o json | jq
```

### Start cluster

```console
minikube start

# Or to specify VM pilote
minikube start --vm-driver=<pilote name>
```

### Open the Kubernetes dashboard in a browser:

```console
minikube dashboard
```

## Samples

- [daxio/k8s-lemp](https://github.com/daxio/k8s-lemp)
- [How To Deploy a PHP Application with Kubernetes on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-php-application-with-kubernetes-on-ubuntu-16-04)
- [Kubernetes Documentation: Example: Deploying WordPress and MySQL with Persistent Volumes](https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)
