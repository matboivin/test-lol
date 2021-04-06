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
service docker restart
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

## Containerize apps

### NGINX

- [Nginx and Letsencrypt with certbot in docker alpine](https://geko.cloud/nginx-and-ssl-with-certbot-in-docker-alpine/)
- [Help the World by Healing Your NGINX Configuration](https://www.nginx.com/blog/help-the-world-by-healing-your-nginx-configuration/)
- [How To Configure Nginx to use TLS 1.2 / 1.3 only](https://www.cyberciti.biz/faq/configure-nginx-to-use-only-tls-1-2-and-1-3/)
- [Protéger Nginx des attaques DoS et bruteforce](https://www.malekal.com/proteger-nginx-attaques-dos-bruteforce/)
- [How to Configure Cache-Control Headers in NGINX](https://www.cloudsavvyit.com/3782/how-to-configure-cache-control-headers-in-nginx/)
- [Add Cache-Control-Header / Expire-Header in NGINX](https://www.digitalocean.com/community/questions/add-cache-control-header-expire-header-in-nginx)
- [How to Cache Content in NGINX](https://www.tecmint.com/cache-content-with-nginx/)
- [How to proxy web apps using nginx?](https://gist.github.com/soheilhy/8b94347ff8336d971ad0)
- [How to set up an easy and secure reverse proxy with Docker, Nginx & Letsencrypt](https://www.freecodecamp.org/news/docker-nginx-letsencrypt-easy-secure-reverse-proxy-40165ba3aee2/)

1 worker -> 1024 connections

> If you add a custom CMD in the Dockerfile, be sure to include -g daemon off; in the CMD in order for nginx to stay in the foreground, so that Docker can track the process properly (otherwise your container will stop immediately after starting)!  [(Source)](https://hub.docker.com/_/nginx)

### vsftpd

- [VSFTPD.CONF](http://vsftpd.beasts.org/vsftpd_conf.html)
- [ArchLinux: Very Secure FTP Daemon](https://wiki.archlinux.org/index.php/Very_Secure_FTP_Daemon)

```sh
nc -zv 192.168.49.2 21
```

Test TLS:

```sh
openssl s_client -connect 192.168.49.2:21 -starttls ftp
```

1. lftp

On 42's VM, install lftp:
```sh
sudo apt install lftp
```

Edit configuration file:
```sh
sudo vim /etc/lftp.conf
```

Add the following lines:
```
set ftp:ssl-force on
set ssl:verify-certificate no
set ssl:priority "NORMAL:-SSL3.0:-TLS1.0:-TLS1.1:+TLS1.2"
```

```sh
lftp -u <user> <IP> -p 21
```

2. Filezilla

On 42's VM, install filezilla:
```sh
sudo apt install filezilla
```

Launch in command line:
```sh
filezilla
```

### TIG stack

Monitor the cluster.

- Telegraf: Agent to collect the cluster data
- InfluxDB: Time series database
- Grafana: Dashboard

- [How To Deploy InfluxDB / Telegraf / Grafana on K8s?](https://octoperf.com/blog/2019/09/19/kraken-kubernetes-influxdb-grafana-telegraf/)
- [Deploy InfluxDB and Grafana on Kubernetes to collect Twitter stats](https://opensource.com/article/19/2/deploy-influxdb-grafana-kubernetes)

### MariaDB

- [Alpine Wiki: MariaDB](https://wiki.alpinelinux.org/wiki/MariaDB)
- [How to set up MariaDB SSL and secure connections from clients](https://www.cyberciti.biz/faq/how-to-setup-mariadb-ssl-and-secure-connections-from-clients/)
- [SSL Configuration Generator](https://ssl-config.mozilla.org/)

### phpMyAdmin

- [phpMyAdmin blowfish secret generator](https://phpsolved.com/phpmyadmin-blowfish-secret-generator/)
- [There is mismatch between HTTPS indicated on the server and client](https://stackoverflow.com/questions/56655548/there-is-mismatch-between-https-indicated-on-the-server-and-client)

### WordPress

- [Set Up Nginx FastCGI Cache to Reduce WordPress Server Response Time](https://www.linuxbabe.com/nginx/setup-nginx-fastcgi-cache)
- [Converting Apache Rewrite Rules to NGINX Rewrite Rules](https://www.nginx.com/blog/converting-apache-to-nginx-rewrite-rules/)
- [Le fichier robots.txt de votre site WordPress est-il optimisé ?](https://wpmarmite.com/robots-txt-wordpress/)

## Load balancer

- [MetalLB documentation: MetalLB installation](https://metallb.universe.tf/installation/)
- [MetalLB documentation: IP address sharing](https://metallb.universe.tf/usage/#ip-address-sharing)
- [Getting external traffic into Kubernetes – ClusterIp, NodePort, LoadBalancer, and Ingress](https://www.ovh.com/blog/getting-external-traffic-into-kubernetes-clusterip-nodeport-loadbalancer-and-ingress/)
- [MetalLB (Network LoadBalancer ) & Minikube.](https://medium.com/@shoaib_masood/metallb-network-loadbalancer-minikube-335d846dfdbe)

**TL;DR** MetalLB is a bare metal load balancer. Its role is to distribute the requests between services of our cluster, depending on the ability of these services to fulfill requests. It ensures no service becomes overworked, reduces incidents and minimizes response time.

type: `LoadBalancer` -> exposes the service externally using a load balancer  
type: `ClusterIP` -> the service is accessible within the cluster, not meant for external access
