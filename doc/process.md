# Process

LEMP stack infrastructure in a kubernetes cluster.

# Steps

## Installation

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

## Start cluster

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

Write Dockerfiles.

#### Create group and user on Alpine

adduser

```
Usage: adduser [OPTIONS] USER [GROUP]

Create new user, or add USER to GROUP

	-h	--home				DIR		Home directory
	-g	--gecos				GECOS	GECOS field
	-s	--shell				SHELL	Login shell
	-G	--ingroup			GRP		Group
	-S	--system			Create a system user
	-D	--disabled-password	Don't assign a password
	-H	--no-create-home	Don't create home directory
	-u	--uid				UID		User id
	-k						SKEL	Skeleton directory (/etc/skel)
```

addgroup

```
Usage: addgroup [-g GID] [-S] [USER] GROUP

Add a group or add a user to a group

	-g	--gid		GID	Group id
	-S	--system	Create a system group
```

chpasswd

```
Usage: chpasswd [--md5|--encrypted|--crypt-method|--root]

Read user:password from stdin and update /etc/passwd

	-e,--encrypted		Supplied passwords are in encrypted form
	-m,--md5		Encrypt using md5, not des
	-c,--crypt-method ALG	des,md5,sha256/512 (default sha512)
	-R,--root DIR		Directory to chroot into
```

- [How do I add a user when I'm using Alpine as a base image?](https://stackoverflow.com/questions/49955097/how-do-i-add-a-user-when-im-using-alpine-as-a-base-image)

#### /var – Variable Data Files

The /var directory is the writable counterpart to the /usr directory, which must be read-only in normal operation. Log files and everything else that would normally be written to /usr during normal operation are written to the /var directory. For example, you’ll find log files in /var/log.

#### /run – Application State Files

The /run directory is fairly new, and gives applications a standard place to store transient files they require like sockets and process IDs. These files can’t be stored in /tmp because files in /tmp may be deleted.

Source: [The Linux Directory Structure, Explained](https://www.howtogeek.com/117435/htg-explains-the-linux-directory-structure-explained/)

### NGINX

- [NGINX official Docker image](https://hub.docker.com/_/nginx)

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

#### Cache

- [How to Cache Content in NGINX](https://www.tecmint.com/cache-content-with-nginx/)

#### Redir / reverse proxy

- [Mettez en place un reverse-proxy avec Nginx](https://openclassrooms.com/fr/courses/1733551-gerez-votre-serveur-linux-et-ses-services/5236081-mettez-en-place-un-reverse-proxy-avec-nginx)
- [How to proxy web apps using nginx?](https://gist.github.com/soheilhy/8b94347ff8336d971ad0)
- [How to get phpmyadmin to work with both a reverse proxy and a plain IP:PMA_PORT connection?](https://serverfault.com/questions/1044014/how-to-get-phpmyadmin-to-work-with-both-a-reverse-proxy-and-a-plain-ippma-port)
- [Wordpress on Docker behind nginx reverse proxy using SSL](https://stackoverflow.com/questions/63135042/wordpress-on-docker-behind-nginx-reverse-proxy-using-ssl)

### MySQL

- [MySQL official Docker image](https://registry.hub.docker.com/_/mysql/)
- [MySQL Docker Containers: Understanding the Basics](https://severalnines.com/database-blog/mysql-docker-containers-understanding-basics)
- [Alpine Wiki: MariaDB](https://wiki.alpinelinux.org/wiki/MariaDB)

Environment Variables [(Source)](https://registry.hub.docker.com/_/mysql/):

- MYSQL_ROOT_PASSWORD
- MYSQL_DATABASE
- MYSQL_USER, MYSQL_PASSWORD
- MYSQL_HOST

[MySQL documentation: Environment Variables](https://dev.mysql.com/doc/refman/5.7/en/environment-variables.html)

`/var/lib/mysql` inside the container: where MySQL by default will write its data files.

```console
/usr/bin/mysqld --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid --skip-grant-tables --skip-networking &

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';FLUSH PRIVILEGES;ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';FLUSH PRIVILEGES;set password = password('MyNewPass');"

kill  `cat /run/mysqld/mysqld.pid`
```

Source: [Alpine Wiki: Restore root password](https://wiki.alpinelinux.org/wiki/Mysql#Restore_root_password) -> store pid then kill process

### WordPress

- [Custom WordPress Docker Setup](https://codingwithmanny.medium.com/custom-wordpress-docker-setup-8851e98e6b8)
- [Kubernetes Documentation: Example: Deploying WordPress and MySQL with Persistent Volumes](https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)
- [How to Run WordPress in Kuberbetes](https://www.serverlab.ca/tutorials/containers/kubernetes/how-to-run-wordpress-in-kuberbetes/)
- [Alpine Wiki: WordPress](https://wiki.alpinelinux.org/wiki/WordPress)

php7-mysql -> deprecated

- [How to install PHP 7 fpm on Alpine Linux](https://www.cyberciti.biz/faq/how-to-install-php-7-fpm-on-alpine-linux/)
- [How to deploy WordPress and MySQL on Kubernetes](https://medium.com/@containerum/how-to-deploy-wordpress-and-mysql-on-kubernetes-bda9a3fdd2d5)
- [How To Deploy a PHP Application with Kubernetes on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-php-application-with-kubernetes-on-ubuntu-16-04)

### PhpMyAdmin

- [Alpine Wiki: PhpMyAdmin](https://wiki.alpinelinux.org/wiki/PhpMyAdmin)
- [Official phpMyAdmin Docker image](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)
- [Deploy PhpMyAdmin on Kubernetes to Manage MySQL Pods](https://www.serverlab.ca/tutorials/containers/kubernetes/deploy-phpmyadmin-to-kubernetes-to-manage-mysql-pods/)

- `PMA_HOST`: define address/host name of the MySQL server
- `PMA_PORT`: define port of the MySQL server

PhpMyAdmin is linked to an existing MySQL service.  
PhpMyAdmin needs the root password of the MySQL service.  

### FTPS server

> FTP (or File Transfer Protocol) is a protocol that allows you to transfer files from a server to a client and vice versa (as FTP uses a client-server architecture).

vsftpd (Very Secure FTP Daemon) -> server

- [Alpine Wiki: FTP](https://wiki.alpinelinux.org/wiki/FTP)
- [How to Install and Configure an FTP server (vsftpd) with SSL/TLS on Ubuntu 20.04](https://www.howtoforge.com/tutorial/ubuntu-vsftpd/)
- [How to setup and use FTP Server in Ubuntu Linux](https://linuxconfig.org/how-to-setup-and-use-ftp-server-in-ubuntu-linux)

> Il existe plusieurs raisons pour lesquelles il est nécessaire de restreindre une session SFTP d’un utilisateur à un dossier particulier sur un serveur Linux. Entre autres, la préservation de l’intégrité des fichiers, la protection contre les logiciels malveillants, et surtout la protection du système.
Pour restreindre les accès SFTP d’un utilisateur à un seul dossier, on peut avoir recours à un chroot jail.  Sur les systèmes d’exploitation basés sur Unix, un chroot jail est une fonctionnalité utilisée pour isoler un processus et ses enfants (child process) du reste du système d’exploitation. Pour des raisons de sécurité, c’est une fonctionnalité qui doit être employée exclusivement sur les processus n’utilisant pas le compte root.  [(Source)](https://homputersecurity.com/2019/05/14/mise-en-place-dune-restriction-chroot-jail-sur-un-dossier-nappartenant-pas-au-compte-root/)

## Load balancer

- [Getting external traffic into Kubernetes – ClusterIp, NodePort, LoadBalancer, and Ingress](https://www.ovh.com/blog/getting-external-traffic-into-kubernetes-clusterip-nodeport-loadbalancer-and-ingress/)

> Usage of Node Port services, Ingress Controller object or kubectl port-forward command is prohibited.  
Your Load Balancer should be the only entry point for the Cluster.

> Un  mécanisme  souple,  implémenté  sous  forme  d’un  protocole  distinct  et  appelé  ARP  (Address Resolution Protocol) permet de déterminer dynamiquement l’adresse MAC à partir de l’adresse IP d’un hôte.  [(Source)](http://www.gipsa-lab.grenoble-inp.fr/~christian.bulfone/MIASHS-L3/PDF/2-Le_protocole_IP.pdf)

- [Ce qu’il faut savoir sur MetalLB](https://www.objectif-libre.com/fr/blog/2019/06/11/metallb/)
- [MetalLB installation](https://metallb.universe.tf/installation/)

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

- [Multi-cluster testing with kind and MetalLB](https://banzaicloud.com/blog/multi-cluster-testing/)

# YAML files

> The resources will be created in the order they appear in the file. Therefore, it's best to specify the service first, since that will ensure the scheduler can spread the pods associated with the service as they are created by the controller(s), such as Deployment.  [(Source)](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)

# Samples

- [daxio/k8s-lemp](https://github.com/daxio/k8s-lemp)
- [How To Deploy a PHP Application with Kubernetes on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-php-application-with-kubernetes-on-ubuntu-16-04)
- [ container-examples / alpine-mysql](https://github.com/container-examples/alpine-mysql/)
