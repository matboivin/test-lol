# Process

Kubernetes cluster composed of:
- a LEMP stack
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

Add user42 to the docker group:

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

```console
minikube start

# Or to specify VM pilote
minikube start --vm-driver=<pilote name>
```

Open the Kubernetes dashboard in a browser:

```console
minikube dashboard
```

Some dashboard features require the metrics-server addon. To enable all features please run:

```console
minikube addons enable metrics-server
```

## Containerize apps

[Write Dockerfiles](containers.md).

> In case of a crash or stop of one of the two database containers, you will have to make shure the data persist.  All your containers must restart in case of a crash or stop of one of its component parts.

> The resources will be created in the order they appear in the file. Therefore, it's best to specify the service first, since that will ensure the scheduler can spread the pods associated with the service as they are created by the controller(s), such as Deployment.  [(Source)](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)

#### Requirements

- [ ] Data persistence
- [ ] Restart in case of crash

## Load balancer

#### Requirements

- [ ] Redirection
- [ ] No NodePort
- [X] No Ingress
- [ ] No `kubectl port-forward`

#### Resources

- [MetalLB documentation: MetalLB installation](https://metallb.universe.tf/installation/)
- [MetalLB documentation: IP address sharing](https://metallb.universe.tf/usage/#ip-address-sharing)
- [Kubernetes Documentation: Create an External Load Balancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/)
- [Ce qu’il faut savoir sur MetalLB](https://www.objectif-libre.com/fr/blog/2019/06/11/metallb/)
- [Getting external traffic into Kubernetes – ClusterIp, NodePort, LoadBalancer, and Ingress](https://www.ovh.com/blog/getting-external-traffic-into-kubernetes-clusterip-nodeport-loadbalancer-and-ingress/)
- [MetalLB (Network LoadBalancer ) & Minikube.](https://medium.com/@shoaib_masood/metallb-network-loadbalancer-minikube-335d846dfdbe)

> Make sure that each redirection toward a service is done using a load balancer. FTPS, Grafana, Wordpress, PhpMyAdmin and nginx’s kind must be "LoadBalancer". Influxdb and MySQL’s kind must be "ClusterIP". Other entries can be present, but none of them can be of kind "NodePort".

> Usage of Node Port services, Ingress Controller object or kubectl port-forward command is prohibited.  
Your Load Balancer should be the only entry point for the Cluster.

> Un  mécanisme  souple,  implémenté  sous  forme  d’un  protocole  distinct  et  appelé  ARP  (Address Resolution Protocol) permet de déterminer dynamiquement l’adresse MAC à partir de l’adresse IP d’un hôte.  [(Source)](http://www.gipsa-lab.grenoble-inp.fr/~christian.bulfone/MIASHS-L3/PDF/2-Le_protocole_IP.pdf)

**TL;DR** MetalLB is a bare metal load balancer. Its role is to distribute the requests between services of our cluster, depending on the ability of these services to fulfill requests. It ensures no service becomes overworked, reduces incidents and minimizes response time.

`type: LoadBalancer` -> exposes the service externally using a load balancer

```
# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
```

> The controller helps in the IP address assignment, whereas the speaker advertises layer -2 address.

```console
kubectl get pods -n metallb-system
```
