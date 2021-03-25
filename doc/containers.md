# Containerize apps

Write Dockerfiles.

**Table of Contents**

1. [Alpine](#alpine)
2. [NGINX](#nginx)
3. [vsftpd](#vsftpd)
4. [Other containers](#other-containers)

## Alpine

#### Requirements

- [X] Alpine 3.13 and not latest

To make images smaller:  
`apk update` + (`rm /var/cache/apk/*` OR `apk add --no-cache`)

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
- [Update BestPractices.md with alpine user](https://github.com/nodejs/docker-node/pull/299)

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
- [X] allow access to a `/wordpress` route that makes a redirect 307 to `IP:WPPORT`
- [X] allow access to `/phpmyadmin` with a reverse proxy to `IP:PMAPORT`

#### Resources

- [NGINX official Docker image](https://hub.docker.com/_/nginx)
- [Alpine Wiki: NGINX](https://wiki.alpinelinux.org/wiki/Nginx)
- [How To Install Nginx web server on Alpine Linux](https://www.cyberciti.biz/faq/how-to-install-nginx-web-server-on-alpine-linux/)
- [Kubernetes Documentation: Connecting Applications with Services](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)
- [Nginx and Letsencrypt with certbot in docker alpine](https://geko.cloud/nginx-and-ssl-with-certbot-in-docker-alpine/)

#### Config

- [NGINX default conf](https://tutoriel-nginx.readthedocs.io/fr/latest/Basic_Config.html)
- [Help the World by Healing Your NGINX Configuration](https://www.nginx.com/blog/help-the-world-by-healing-your-nginx-configuration/)
- [How To Configure Nginx to use TLS 1.2 / 1.3 only](https://www.cyberciti.biz/faq/configure-nginx-to-use-only-tls-1-2-and-1-3/)
- [Protéger Nginx des attaques DoS et bruteforce](https://www.malekal.com/proteger-nginx-attaques-dos-bruteforce/)

#### Cache

- [How to Configure Cache-Control Headers in NGINX](https://www.cloudsavvyit.com/3782/how-to-configure-cache-control-headers-in-nginx/)
- [Add Cache-Control-Header / Expire-Header in NGINX](https://www.digitalocean.com/community/questions/add-cache-control-header-expire-header-in-nginx)
- [How to Cache Content in NGINX](https://www.tecmint.com/cache-content-with-nginx/)

#### Redir / reverse proxy

- [Mettez en place un reverse-proxy avec Nginx](https://openclassrooms.com/fr/courses/1733551-gerez-votre-serveur-linux-et-ses-services/5236081-mettez-en-place-un-reverse-proxy-avec-nginx)
- [How to proxy web apps using nginx?](https://gist.github.com/soheilhy/8b94347ff8336d971ad0)
- [How to get phpmyadmin to work with both a reverse proxy and a plain IP:PMA_PORT connection?](https://serverfault.com/questions/1044014/how-to-get-phpmyadmin-to-work-with-both-a-reverse-proxy-and-a-plain-ippma-port)
- [How to set up an easy and secure reverse proxy with Docker, Nginx & Letsencrypt](https://www.freecodecamp.org/news/docker-nginx-letsencrypt-easy-secure-reverse-proxy-40165ba3aee2/)

server blocks -> pour encapsuler les détails de configuration et héberger plusieurs domaines sur un seul serveur  
1 worker -> 1024 connections

> If you add a custom CMD in the Dockerfile, be sure to include -g daemon off; in the CMD in order for nginx to stay in the foreground, so that Docker can track the process properly (otherwise your container will stop immediately after starting)!  [(Source)](https://hub.docker.com/_/nginx)

Log files:
- `/var/log/nginx/access.log`
- `/var/log/nginx/error.log`

## vsftpd

#### Requirements

- [X] vsftpd 3.0.3-r6
- [X] type LoadBalancer
- [X] port 21
- [X] FTPS

#### Resources

- [Alpine Wiki: FTP](https://wiki.alpinelinux.org/wiki/FTP)
- [VSFTPD.CONF](http://vsftpd.beasts.org/vsftpd_conf.html)
- [Wiki Ubuntu: VSFTPD](https://doc.ubuntu-fr.org/vsftpd)
- [How to Install and Configure an FTP server (vsftpd) with SSL/TLS on Ubuntu 20.04](https://www.howtoforge.com/tutorial/ubuntu-vsftpd/)
- [How to setup and use FTP Server in Ubuntu Linux](https://linuxconfig.org/how-to-setup-and-use-ftp-server-in-ubuntu-linux)
- [How To Set Up vsftpd for Anonymous Downloads on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-anonymous-downloads-on-ubuntu-16-04)
- [ArchLinux: Very Secure FTP Daemon](https://wiki.archlinux.org/index.php/Very_Secure_FTP_Daemon)
- [Configure VSFTPD with an SSL](https://www.liquidweb.com/kb/configure-vsftpd-ssl/)
- [VSFTP (avec certificat SSL)](http://ressources-info.fr/tutoriels-systemes/afficher/8/)
- [Ftps server doesn't work properly using kubernetes](https://stackoverflow.com/questions/60458028/ftps-server-doesnt-work-properly-using-kubernetes)

#### Config

> FTP (or File Transfer Protocol) is a protocol that allows you to transfer files from a server to a client and vice versa (as FTP uses a client-server architecture).

No persistence?

vsftpd (Very Secure FTP Daemon) -> server

> Il existe plusieurs raisons pour lesquelles il est nécessaire de restreindre une session SFTP d’un utilisateur à un dossier particulier sur un serveur Linux. Entre autres, la préservation de l’intégrité des fichiers, la protection contre les logiciels malveillants, et surtout la protection du système.
Pour restreindre les accès SFTP d’un utilisateur à un seul dossier, on peut avoir recours à un chroot jail.  Sur les systèmes d’exploitation basés sur Unix, un chroot jail est une fonctionnalité utilisée pour isoler un processus et ses enfants (child process) du reste du système d’exploitation. Pour des raisons de sécurité, c’est une fonctionnalité qui doit être employée exclusivement sur les processus n’utilisant pas le compte root.  [(Source)](https://homputersecurity.com/2019/05/14/mise-en-place-dune-restriction-chroot-jail-sur-un-dossier-nappartenant-pas-au-compte-root/)

## Other containers

- [LEMP Stack + PMA + WordPress](lemp-stack.md)
- [TIG stack](tig-stack.md)
