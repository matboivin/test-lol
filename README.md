# ft_services

### Disclaimer

This project is a school assignment. It was done for **learning purposes** and is thus **not intended for production**.  
Don't copy. Learn.  

## Components

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

## Usage

## Prerequisites

This project is to be run inside 42's VM.

- 2 CPUs or more
- 2GB of free memory
- 20GB of free disk space

Add user42 to the Docker group:

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
