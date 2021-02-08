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

Open the Kubernetes dashboard in a browser:

```console
minikube dashboard
```

### Containerize apps

Write Dockerfiles.

#### NGINX

Containers have to be build using Alpine Linux.  
-> version 3.13

- A container with a nginx server listening on ports 80 and 443.
  - Port 80 will be in http and should be a systematic redirection of type 301 to 443, which will be in https.
  - The page displayed does not matter as long as it is not an http error.
  - This container will allow access to a /wordpress route that makes a redirect 307 to IP:WPPORT.
  - It should also allow access to /phpmyadmin with a reverse proxy to IP:PMAPORT.

- [How To Install Nginx web server on Alpine Linux](https://www.cyberciti.biz/faq/how-to-install-nginx-web-server-on-alpine-linux/)

To make images smaller:  
`apk update` + `rm /var/cache/apk/*` OR `apk add --no-cache`

- [Alpine Dockerfile Advantages of --no-cache Vs. rm /var/cache/apk/*](https://stackoverflow.com/questions/49118579/alpine-dockerfile-advantages-of-no-cache-vs-rm-var-cache-apk/49119046)

> If you wish to adapt the default configuration, use something like the following to copy it from a running nginx container:  `$ docker cp tmp-nginx-container:/etc/nginx/nginx.conf /host/path/nginx.conf`  [(Source)](https://hub.docker.com/_/nginx)

- [NGINX default conf](https://tutoriel-nginx.readthedocs.io/fr/latest/Basic_Config.html)
- [Update BestPractices.md with alpine user](https://github.com/nodejs/docker-node/pull/299)
- [Alpine Wiki: NGINX](https://wiki.alpinelinux.org/wiki/Nginx)

> If you add a custom CMD in the Dockerfile, be sure to include -g daemon off; in the CMD in order for nginx to stay in the foreground, so that Docker can track the process properly (otherwise your container will stop immediately after starting)!  [(Source)](https://hub.docker.com/_/nginx)

Log files:
- `/var/log/nginx/access.log`
- `/var/log/nginx/error.log`

## Samples

- [daxio/k8s-lemp](https://github.com/daxio/k8s-lemp)
- [How To Deploy a PHP Application with Kubernetes on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-php-application-with-kubernetes-on-ubuntu-16-04)
- [Kubernetes Documentation: Example: Deploying WordPress and MySQL with Persistent Volumes](https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)
