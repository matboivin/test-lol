# LEMP Stack + PMA + WordPress

LEMP stack stands for:

- Linux operating system
- NGINX web server
- MySQL/MariaDB database to store the backend data
- PHP to handle dynamic processing

**Table of Contents**

1. [MySQL](#mysql)
2. [phpMyAdmin](#phpmyadmin)
3. [WordPress](#wordpress)

## MySQL

#### Requirements

- [X] MariaDB 10.5.8
- [X] ClusterIP
- [X] data persistence

#### Resources

- [MySQL official Docker image](https://registry.hub.docker.com/_/mysql/)
- [Alpine Wiki: MariaDB](https://wiki.alpinelinux.org/wiki/MariaDB)
- [How to set up MariaDB SSL and secure connections from clients](https://www.cyberciti.biz/faq/how-to-setup-mariadb-ssl-and-secure-connections-from-clients/)
- [Creating Database for WordPress](https://wordpress.org/support/article/creating-database-for-wordpress/)

#### Config

- [SSL Configuration Generator](https://ssl-config.mozilla.org/)

```console
/usr/bin/mysqld --datadir=/var/lib/mysql --pid-file=/run/mysqld/mysqld.pid --skip-grant-tables --skip-networking &

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';FLUSH PRIVILEGES;ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';FLUSH PRIVILEGES;set password = password('MyNewPass');"

kill  `cat /run/mysqld/mysqld.pid`
```

Source: [Alpine Wiki: Restore root password](https://wiki.alpinelinux.org/wiki/Mysql#Restore_root_password) -> store pid then kill process

## phpMyAdmin

#### Requirements

- [X] phpMyAdmin 5.1.0
- [X] port 5000
- [X] type LoadBalancer
- [X] PHP 7.4 or greater
- [X] linked to MySQL
- [X] the root password of the MySQL service

#### Resources

- [phpMyAdmin official Docker image](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)
- [Alpine Wiki: phpMyAdmin](https://wiki.alpinelinux.org/wiki/phpMyAdmin)
- [Arch Wiki: phpMyAdmin](https://wiki.archlinux.org/index.php/PhpMyAdmin)

#### Config

- [phpMyAdmin blowfish secret generator](https://phpsolved.com/phpmyadmin-blowfish-secret-generator/)
- [There is mismatch between HTTPS indicated on the server and client](https://stackoverflow.com/questions/56655548/there-is-mismatch-between-https-indicated-on-the-server-and-client)

phpMyAdmin is linked to an existing MySQL service.  
phpMyAdmin needs the root password of the MySQL service.  

## WordPress

#### Requirements

- [X] type LoadBalancer
- [X] port 5050
- [X] WordPress 5.6.2
- [X] PHP 7.4 or greater
- [X] NGINX `mod_rewrite` module
- [X] HTTPS support
- [X] linked to MySQL
- [X] several users and an administrator

#### Resources

- [Alpine Wiki: WordPress](https://wiki.alpinelinux.org/wiki/WordPress)
- [Kubernetes Documentation: Example: Deploying WordPress and MySQL with Persistent Volumes](https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)
- [Set Up Nginx FastCGI Cache to Reduce WordPress Server Response Time](https://www.linuxbabe.com/nginx/setup-nginx-fastcgi-cache)
- [Converting Apache Rewrite Rules to NGINX Rewrite Rules](https://www.nginx.com/blog/converting-apache-to-nginx-rewrite-rules/)

#### Config

- [NGINX WordPress config](https://www.nginx.com/resources/wiki/start/topics/recipes/wordpress/)
- [WordPress: Requirements](https://wordpress.org/support/article/requirements/)
- [WordPress: Server environment](https://make.wordpress.org/hosting/handbook/handbook/server-environment/)

robots.txt: [Le fichier robots.txt de votre site WordPress est-il optimisé ?](https://wpmarmite.com/robots-txt-wordpress/)
