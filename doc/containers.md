# Containerize apps

Write Dockerfiles.

**Table of Contents**

1. [Versions](#versions)
2. [Alpine](#alpine)
3. [NGINX](#nginx)
4. [MySQL](#mysql)
5. [WordPress](#wordpress)
6. [phpMyAdmin](#phpmyadmin)
7. [FTPS server](#ftps-server)
8. [Grafana](#grafana)
9. [InfluxDB](#influxdb)

## Versions

- minikube v1.17.1
- kubectl v1.20.2
- Alpine 3.13
- NGINX 1.18.0-r13
- openssl 1.1.1
- WordPress 5.6.2
- PHP 7.4.15
- phpMyAdmin 5.1.0
- MariaDB 10.5.8
- vsftpd 3.0.3-r6
- Grafana 7.3.6-r0
- InfluxDB 1.8.3-r2
- Telegraf 1.17.0-r0

## Alpine

#### Requirements

- [X] Alpine 3.13 and not latest

To make images smaller:  
`apk update` + `rm /var/cache/apk/*` OR `apk add --no-cache`

> The --no-cache option allows to not cache the index locally, which is useful for keeping containers small.  
Literally it equals `apk update` in the beginning and `rm -rf /var/cache/apk/*` in the end.

Source: [Alpine Dockerfile Advantages of --no-cache Vs. rm /var/cache/apk/*](https://stackoverflow.com/questions/49118579/alpine-dockerfile-advantages-of-no-cache-vs-rm-var-cache-apk/49119046)

### Create group and user on Alpine

`adduser`

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

`addgroup`

```
Usage: addgroup [-g GID] [-S] [USER] GROUP

Add a group or add a user to a group

	-g	--gid		GID	Group id
	-S	--system	Create a system group
```

`chpasswd`

```
Usage: chpasswd [--md5|--encrypted|--crypt-method|--root]

Read user:password from stdin and update /etc/passwd

	-e,--encrypted		Supplied passwords are in encrypted form
	-m,--md5		Encrypt using md5, not des
	-c,--crypt-method ALG	des,md5,sha256/512 (default sha512)
	-R,--root DIR		Directory to chroot into
```

- [How do I add a user when I'm using Alpine as a base image?](https://stackoverflow.com/questions/49955097/how-do-i-add-a-user-when-im-using-alpine-as-a-base-image)

### Directory structure

#### /etc – Configuration Files

The `/etc` directory contains configuration files, which can generally be edited by hand in a text editor. Note that the `/etc/` directory contains system-wide configuration files – user-specific configuration files are located in each user’s home directory.

#### /var – Variable Data Files

The `/var` directory is the writable counterpart to the `/usr` directory, which must be read-only in normal operation. Log files and everything else that would normally be written to `/usr` during normal operation are written to the /var directory. For example, you’ll find log files in `/var/log`.

#### /run – Application State Files

The `/run` directory is fairly new, and gives applications a standard place to store transient files they require like sockets and process IDs. These files can’t be stored in `/tmp` because files in `/tmp` may be deleted.

Source: [The Linux Directory Structure, Explained](https://www.howtogeek.com/117435/htg-explains-the-linux-directory-structure-explained/)

## NGINX

#### Requirements

- [X] type LoadBalancer
- [X] ports 80 and 443
- [X] The page displayed does not matter as long as it is not an http error
- [X] NGINX conf
- [ ] allow access to a `/wordpress` route that makes a redirect 307 to `IP:WPPORT`
- [ ] allow access to `/phpmyadmin` with a reverse proxy to `IP:PMAPORT`
- [X] 404 page, 50x page, robots.txt

#### Resources

- [NGINX official Docker image](https://hub.docker.com/_/nginx)
- [Alpine Wiki: NGINX](https://wiki.alpinelinux.org/wiki/Nginx)
- [How To Install Nginx web server on Alpine Linux](https://www.cyberciti.biz/faq/how-to-install-nginx-web-server-on-alpine-linux/)
- [Update BestPractices.md with alpine user](https://github.com/nodejs/docker-node/pull/299)
- [NGINX doc: ngx_http_core_module](https://nginx.org/en/docs/http/ngx_http_core_module.html)
- [Help the World by Healing Your NGINX Configuration](https://www.nginx.com/blog/help-the-world-by-healing-your-nginx-configuration/)
- [Protéger Nginx des attaques DoS et bruteforce](https://www.malekal.com/proteger-nginx-attaques-dos-bruteforce/)
- [How To Configure Nginx to use TLS 1.2 / 1.3 only](https://www.cyberciti.biz/faq/configure-nginx-to-use-only-tls-1-2-and-1-3/)
- [Nginx and Letsencrypt with certbot in docker alpine](https://geko.cloud/nginx-and-ssl-with-certbot-in-docker-alpine/)
- [Kubernetes Documentation: Connecting Applications with Services](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)

#### Config

- [NGINX default conf](https://tutoriel-nginx.readthedocs.io/fr/latest/Basic_Config.html)
- [NGINXConfig](https://www.digitalocean.com/community/tools/nginx)

> If you wish to adapt the default configuration, use something like the following to copy it from a running nginx container:  `$ docker cp tmp-nginx-container:/etc/nginx/nginx.conf /host/path/nginx.conf`  [(Source)](https://hub.docker.com/_/nginx)

> If you add a custom CMD in the Dockerfile, be sure to include -g daemon off; in the CMD in order for nginx to stay in the foreground, so that Docker can track the process properly (otherwise your container will stop immediately after starting)!  [(Source)](https://hub.docker.com/_/nginx)

Log files:
- `/var/log/nginx/access.log`
- `/var/log/nginx/error.log`

server blocks -> pour encapsuler les détails de configuration et héberger plusieurs domaines sur un seul serveur  
1 worker -> 1024 connections  

#### Cache

- [How to Configure Cache-Control Headers in NGINX](https://www.cloudsavvyit.com/3782/how-to-configure-cache-control-headers-in-nginx/)
- [Add Cache-Control-Header / Expire-Header in NGINX](https://www.digitalocean.com/community/questions/add-cache-control-header-expire-header-in-nginx)
- [How to Cache Content in NGINX](https://www.tecmint.com/cache-content-with-nginx/)

#### Redir / reverse proxy

- [Mettez en place un reverse-proxy avec Nginx](https://openclassrooms.com/fr/courses/1733551-gerez-votre-serveur-linux-et-ses-services/5236081-mettez-en-place-un-reverse-proxy-avec-nginx)
- [How to proxy web apps using nginx?](https://gist.github.com/soheilhy/8b94347ff8336d971ad0)
- [How to get phpmyadmin to work with both a reverse proxy and a plain IP:PMA_PORT connection?](https://serverfault.com/questions/1044014/how-to-get-phpmyadmin-to-work-with-both-a-reverse-proxy-and-a-plain-ippma-port)
- [Wordpress on Docker behind nginx reverse proxy using SSL](https://stackoverflow.com/questions/63135042/wordpress-on-docker-behind-nginx-reverse-proxy-using-ssl)

## LEMP STACK

### MySQL

#### Requirements

- [X] MariaDB 10.5.8
- [ ] ClusterIP
- [ ] data persistence

#### Resources

- [MySQL official Docker image](https://registry.hub.docker.com/_/mysql/)
- [Alpine Wiki: MariaDB](https://wiki.alpinelinux.org/wiki/MariaDB)
- [MySQL Docker Containers: Understanding the Basics](https://severalnines.com/database-blog/mysql-docker-containers-understanding-basics)
- [MySQL documentation: Environment Variables](https://dev.mysql.com/doc/refman/5.7/en/environment-variables.html)

#### Config

Environment Variables [(Source)](https://registry.hub.docker.com/_/mysql/):

- MYSQL_ROOT_PASSWORD
- MYSQL_DATABASE
- MYSQL_USER, MYSQL_PASSWORD
- MYSQL_HOST

`/var/lib/mysql` inside the container: where MySQL by default will write its data files.

```console
/usr/bin/mysqld --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid --skip-grant-tables --skip-networking &

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';FLUSH PRIVILEGES;ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';FLUSH PRIVILEGES;set password = password('MyNewPass');"

kill  `cat /run/mysqld/mysqld.pid`
```

Source: [Alpine Wiki: Restore root password](https://wiki.alpinelinux.org/wiki/Mysql#Restore_root_password) -> store pid then kill process

### WordPress

#### Requirements

- [X] type LoadBalancer
- [X] port 5050
- [X] WordPress 5.6.2
- [X] PHP 7.4 or greater
- [X] NGINX conf, `mod_rewrite` module
- [ ] HTTPS support
- [ ] linked to MySQL
- [ ] several users and an administrator

#### Resources

- [Alpine Wiki: WordPress](https://wiki.alpinelinux.org/wiki/WordPress)
- [Custom WordPress Docker Setup](https://codingwithmanny.medium.com/custom-wordpress-docker-setup-8851e98e6b8)
- [Kubernetes Documentation: Example: Deploying WordPress and MySQL with Persistent Volumes](https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)
- [How to Run WordPress in Kuberbetes](https://www.serverlab.ca/tutorials/containers/kubernetes/how-to-run-wordpress-in-kuberbetes/)
- [How to install PHP 7 fpm on Alpine Linux](https://www.cyberciti.biz/faq/how-to-install-php-7-fpm-on-alpine-linux/)
- [How to deploy WordPress and MySQL on Kubernetes](https://medium.com/@containerum/how-to-deploy-wordpress-and-mysql-on-kubernetes-bda9a3fdd2d5)
- [How To Deploy a PHP Application with Kubernetes on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-php-application-with-kubernetes-on-ubuntu-16-04)
- [Set Up Nginx FastCGI Cache to Reduce WordPress Server Response Time](https://www.linuxbabe.com/nginx/setup-nginx-fastcgi-cache)
- [Converting Apache Rewrite Rules to NGINX Rewrite Rules](https://www.nginx.com/blog/converting-apache-to-nginx-rewrite-rules/)

#### Config

To run WordPress we recommend your host supports:

- PHP 7.4 or greater
- MySQL 5.6 or greater OR MariaDB 10.1 or greater
- Nginx or Apache with mod_rewrite module
- HTTPS support

packet `php7-mysql` -> deprecated

robots.txt: [Le fichier robots.txt de votre site WordPress est-il optimisé ?](https://wpmarmite.com/robots-txt-wordpress/)

### phpMyAdmin

#### Requirements

- [X] phpMyAdmin 5.1.0
- [X] port 5000
- [X] type LoadBalancer
- [X] PHP 7.4 or greater
- [X] NGINX conf
- [ ] linked to MySQL
- [ ] the root password of the MySQL service

#### Resources

- [phpMyAdmin official Docker image](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)
- [Alpine Wiki: phpMyAdmin](https://wiki.alpinelinux.org/wiki/phpMyAdmin)
- [Deploy phpMyAdmin on Kubernetes to Manage MySQL Pods](https://www.serverlab.ca/tutorials/containers/kubernetes/deploy-phpmyadmin-to-kubernetes-to-manage-mysql-pods/)

#### Config

phpMyAdmin is linked to an existing MySQL service.  
phpMyAdmin needs the root password of the MySQL service.  

- `PMA_HOST`: define address/host name of the MySQL server
- `PMA_PORT`: define port of the MySQL server

## FTPS server

#### Requirements

- [X] vsftpd 3.0.3-r6
- [X] type LoadBalancer
- [X] port 21
- [ ] FTPS

#### Config

> FTP (or File Transfer Protocol) is a protocol that allows you to transfer files from a server to a client and vice versa (as FTP uses a client-server architecture).

No persistence?

vsftpd (Very Secure FTP Daemon) -> server

#### Resources

- [Alpine Wiki: FTP](https://wiki.alpinelinux.org/wiki/FTP)
- [VSFTPD.CONF](http://vsftpd.beasts.org/vsftpd_conf.html)
- [How to Install and Configure an FTP server (vsftpd) with SSL/TLS on Ubuntu 20.04](https://www.howtoforge.com/tutorial/ubuntu-vsftpd/)
- [How to setup and use FTP Server in Ubuntu Linux](https://linuxconfig.org/how-to-setup-and-use-ftp-server-in-ubuntu-linux)
- [How To Set Up vsftpd for Anonymous Downloads on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-anonymous-downloads-on-ubuntu-16-04)
- [ArchLinux: Very Secure FTP Daemon](https://wiki.archlinux.org/index.php/Very_Secure_FTP_Daemon)
- [Configure VSFTPD with an SSL](https://www.liquidweb.com/kb/configure-vsftpd-ssl/)
- [VSFTP (avec certificat SSL)](http://ressources-info.fr/tutoriels-systemes/afficher/8/)
- [Ftps server doesn't work properly using kubernetes](https://stackoverflow.com/questions/60458028/ftps-server-doesnt-work-properly-using-kubernetes)
- [Telegraf configuration](https://github.com/influxdata/telegraf/blob/master/docs/CONFIGURATION.md)

> Il existe plusieurs raisons pour lesquelles il est nécessaire de restreindre une session SFTP d’un utilisateur à un dossier particulier sur un serveur Linux. Entre autres, la préservation de l’intégrité des fichiers, la protection contre les logiciels malveillants, et surtout la protection du système.
Pour restreindre les accès SFTP d’un utilisateur à un seul dossier, on peut avoir recours à un chroot jail.  Sur les systèmes d’exploitation basés sur Unix, un chroot jail est une fonctionnalité utilisée pour isoler un processus et ses enfants (child process) du reste du système d’exploitation. Pour des raisons de sécurité, c’est une fonctionnalité qui doit être employée exclusivement sur les processus n’utilisant pas le compte root.  [(Source)](https://homputersecurity.com/2019/05/14/mise-en-place-dune-restriction-chroot-jail-sur-un-dossier-nappartenant-pas-au-compte-root/)

## TIG Stack

- Telegraf: Agent to collect the cluster data
- InfluxDB: Time series database
- Grafana: Dashboard

#### Resources

- [How To Deploy InfluxDB / Telegraf / Grafana on K8s?](https://octoperf.com/blog/2019/09/19/kraken-kubernetes-influxdb-grafana-telegraf/#map-a-configuration-file-using-configmap)
- [TIG, le trio Telegraf + InfluxDB + Grafana pour surveiller vos équipements](https://domopi.eu/tig-le-trio-telegraf-influxdb-grafana-pour-surveiller-vos-equipements/)
- [[DIY] Set Up Telegraf, InfluxDB, & Grafana on Kubernetes](https://blog.gojekengineering.com/diy-set-up-telegraf-influxdb-grafana-on-kubernetes-d55e32f8ce48)

> Le monitoring ou surpervision est une activité de surveillance et de mesure d’une activité informatique. Ces mesures permettent de construire des graphes afin de visualiser les performances et de voir les tendances, de détecter voire d’anticiper des anomalies ou des pannes et d’alerter en cas de dysfonctionnement.  [(Source)](https://domopi.eu/tig-le-trio-telegraf-influxdb-grafana-pour-surveiller-vos-equipements/)

## Grafana

#### Requirements

- [X] Grafana 7.3.6-r0
- [X] type LoadBalancer
- [X] port 3000
- [ ] linked to InfluxDB
- [ ] one dashboard per service

#### Resources

- [Monitorer votre infra avec Telegraf, InfluxDB et Grafana](https://blog.octo.com/monitorer-votre-infra-avec-telegraf-influxdb-et-grafana/)
- [Monitoring Kubernetes with Grafana and InfluxDB](https://logz.io/blog/monitoring-kubernetes-grafana-influxdb/)
- [How To Install InfluxDB Telegraf and Grafana on Docker](https://devconnected.com/how-to-install-influxdb-telegraf-and-grafana-on-docker/)
- [Grafana Labs: Download Grafana](https://grafana.com/grafana/download?edition=enterprise&platform=linux)
- [Grafana Labs: Install Grafana](https://grafana.com/docs/grafana/latest/installation/)
- [Grafana Labs: Configure a Grafana Docker image](https://grafana.com/docs/grafana/latest/administration/configure-docker/)
- [Deploy InfluxDB and Grafana on Kubernetes to collect Twitter stats](https://opensource.com/article/19/2/deploy-influxdb-grafana-kubernetes)

Select open-source version:

```sh
wget https://dl.grafana.com/oss/release/grafana-7.4.3.linux-amd64.tar.gz
tar -zxvf grafana-7.4.3.linux-amd64.tar.gz
```

> You must restart Grafana for any configuration changes to take effect.  [(Source)](https://grafana.com/docs/grafana/latest/administration/configuration/)

Set the default paths like the [Official Docker Image](https://grafana.com/docs/grafana/latest/administration/configure-docker/):

- GF_PATHS_CONFIG `/etc/grafana/grafana.ini`
- GF_PATHS_DATA `/var/lib/grafana`
- GF_PATHS_HOME `/usr/share/grafana`
- GF_PATHS_LOGS `/var/log/grafana`
- GF_PATHS_PLUGINS `/var/lib/grafana/plugins`
- GF_PATHS_PROVISIONING `/etc/grafana/provisioning`

Do not change `defaults.ini`! Grafana defaults are stored in this file. Depending on your OS, make all configuration changes in either `custom.ini` or `grafana.ini`.  
- Default configuration from `$WORKING_DIR/conf/defaults.ini`  
- Custom configuration from `$WORKING_DIR/conf/custom.ini`  
- The custom configuration file path can be overridden using the `--config` parameter

Source: [Grafana Labs: Config file locations](https://grafana.com/docs/grafana/latest/administration/configuration/)

To invoke Grafana CLI, add the path to the grafana binaries in your `PATH` environment variable. Alternately, if your current directory is the bin directory, use `./grafana-cli`. Otherwise, you can specify full path to the CLI. For example, on Linux `/usr/share/grafana/bin/grafana-cli` and on Windows `C:\Program Files\GrafanaLabs\grafana\bin\grafana-cli.exe`.

Source: [Grafana Labs: Grafana CLI](https://grafana.com/docs/grafana/latest/administration/cli/)

Can't find `grafana-cli` on Alpine-based Docker image: [Problem with the linux binaries on Alpine](https://github.com/github/hub/issues/1818)

- GF_SECURITY_ADMIN_PASSWORD__FILE `/run/secrets/<name of secret>`

## InfluxDB

#### Requirements

- [X] InfluxDB 1.8.3-r2
- [ ] ClusterIP
- [ ] data persistence

#### Resources

- [InfluxDB official Docker image](https://hub.docker.com/_/influxdb)
- [InfluxDB ports](https://docs.influxdata.com/influxdb/v1.8/administration/ports/)
- [Get started with InfluxDB OSS v1.8](https://docs.influxdata.com/influxdb/v1.8/introduction/get-started/)
- [How To Install InfluxDB 1.7 and 2.0 on Linux in 2019](https://devconnected.com/how-to-install-influxdb-on-ubuntu-debian-in-2019/#Option_2_Adding_the_repositories_to_your_package_manager)
- [InfluxDB : une base de données time series open source ultra-rapide](https://www.journaldunet.fr/web-tech/guide-de-l-entreprise-digitale/1443846-influxdb-une-base-de-donnees-time-series-open-source-sur-optimisee/)
- [InfluxDB v1.8 config](https://github.com/influxdata/docs-v2/blob/00aadfceaa99de0d05610eb0617e56f1232c9153/content/influxdb/v1.8/administration/config.mds)
- [InfluxDB v1.8 Docker Alpine config](https://github.com/influxdata/influxdata-docker/blob/master/influxdb/1.8/alpine/influxdb.conf)
- [Monitor Docker](https://docs.influxdata.com/influxdb/v2.0/monitor-alert/templates/infrastructure/docker/)

8086 -> HTTP API port  
> The CLI communicates with InfluxDB directly by making requests to the InfluxDB API over port 8086 by default.

- INFLUXDB_CONFIG_PATH `/etc/influxdb/influxdb.conf`

`/usr/sbin/influxd`
```
Configure and start an InfluxDB server.

Usage: influxd [[command] [arguments]]

The commands are:

    backup               downloads a snapshot of a data node and saves it to disk
    config               display the default configuration
    help                 display this help message
    restore              uses a snapshot of a data node to rebuild a cluster
    run                  run node with existing configuration
    version              displays the InfluxDB version

"run" is the default command.
```

`influxd run`
```
Runs the InfluxDB server.

Usage: influxd run [flags]

    -config <path>
            Set the path to the configuration file.
            This defaults to the environment variable INFLUXDB_CONFIG_PATH,
            ~/.influxdb/influxdb.conf, or /etc/influxdb/influxdb.conf if a file
            is present at any of these locations.
            Disable the automatic loading of a configuration file using
            the null device (such as /dev/null).
    -pidfile <path>
            Write process ID to a file.
    -cpuprofile <path>
            Write CPU profiling information to a file.
    -memprofile <path>
            Write memory usage information to a file.
```

`influxd` PID file -> `/var/log/influxdb/influxd.log`

To create an InfluxDB configuration file using Docker, run the following command:

```console
docker run --rm influxdb:ft influxd config > influxdb.conf
```

Source: [How To Install InfluxDB Telegraf and Grafana on Docker](https://devconnected.com/how-to-install-influxdb-telegraf-and-grafana-on-docker/)

The config is mounted as a ConfigMap.

- [kubeapps: InfluxDB](https://hub.kubeapps.com/charts/bitnami/influxdb)
- [How To Deploy InfluxDB / Telegraf / Grafana on K8s?](https://octoperf.com/blog/2019/09/19/kraken-kubernetes-influxdb-grafana-telegraf/#how-to-deploy-influxdb)
- [influxdata config.yaml](https://github.com/influxdata/kube-influxdb/blob/master/influxdb/templates/config.yaml)

## Telegraf

#### Requirements

- [X] Telegraf 1.17.0-r0

#### Resources

- [Telegraf official Docker image](https://hub.docker.com/_/telegraf)
- [Telegraf configuration](https://github.com/influxdata/telegraf/blob/master/docs/CONFIGURATION.md)

```console
docker run --rm telegraf:ft telegraf config
```
