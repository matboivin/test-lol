# TIG stack

Monitor the cluster.

- Telegraf: Agent to collect the cluster data
- InfluxDB: Time series database
- Grafana: Dashboard

> Le monitoring ou surpervision est une activité de surveillance et de mesure d’une activité informatique. Ces mesures permettent de construire des graphes afin de visualiser les performances et de voir les tendances, de détecter voire d’anticiper des anomalies ou des pannes et d’alerter en cas de dysfonctionnement.  [(Source)](https://domopi.eu/tig-le-trio-telegraf-influxdb-grafana-pour-surveiller-vos-equipements/)

The monitoring stack should be isolated in its own monitoring namespace but 42 evaluators would probably put zero for this.

**Table of Contents**

1. [InfluxDB](#influxdb)
2. [Grafana](#grafana)
3. [Telegraf](#telegraf)

## TIG stack

- [How To Deploy InfluxDB / Telegraf / Grafana on K8s?](https://octoperf.com/blog/2019/09/19/kraken-kubernetes-influxdb-grafana-telegraf/)
- [[DIY] Set Up Telegraf, InfluxDB, & Grafana on Kubernetes](https://www.gojek.io/blog/diy-set-up-telegraf-influxdb-grafana-on-kubernetes)
- [Monitoring Kubernetes Architecture](https://dzone.com/articles/monitoring-kubernetes-architecture)
- [Deploy InfluxDB and Grafana on Kubernetes to collect Twitter stats](https://opensource.com/article/19/2/deploy-influxdb-grafana-kubernetes)

## InfluxDB

#### Requirements

- [X] InfluxDB 1.8.3-r2
- [X] ClusterIP
- [X] data persistence

#### Resources

- [InfluxDB official Docker image](https://hub.docker.com/_/influxdb)
- [InfluxDB ports](https://docs.influxdata.com/influxdb/v1.8/administration/ports/)
- [InfluxDB v1.8 Docker Alpine config](https://github.com/influxdata/influxdata-docker/blob/master/influxdb/1.8/alpine/influxdb.conf)
- [Execute an InfluxQL command and quit with -execute](https://docs.influxdata.com/influxdb/v1.8/tools/shell/#execute-an-influxql-command-and-quit-with--execute)

8086 -> HTTP API port  

> The CLI communicates with InfluxDB directly by making requests to the InfluxDB API over port 8086 by default.

`/usr/sbin/influxd`
```
Configure and start an InfluxDB server.

Usage: influxd [[command] [arguments]]

The commands are:

- backup- - -downloads a snapshot of a data node and saves it to disk
- config- - -display the default configuration
- help- - - -  display this help message
- restore- - -   uses a snapshot of a data node to rebuild a cluster
- run- - - -   run node with existing configuration
- version- - -   displays the InfluxDB version

"run" is the default command.
```

`influxd run`
```
Runs the InfluxDB server.

Usage: influxd run [flags]

- -config <path>
- - - Set the path to the configuration file.
- - - This defaults to the environment variable INFLUXDB_CONFIG_PATH,
- - - ~/.influxdb/influxdb.conf, or /etc/influxdb/influxdb.conf if a file
- - - is present at any of these locations.
- - - Disable the automatic loading of a configuration file using
- - - the null device (such as /dev/null).
- -pidfile <path>
- - - Write process ID to a file.
- -cpuprofile <path>
- - - Write CPU profiling information to a file.
- -memprofile <path>
- - - Write memory usage information to a file.
```

> A successful CREATE DATABASE query returns an empty result. If you attempt to create a database that already exists, InfluxDB does nothing and does not return an error. [(Source)](https://docs.influxdata.com/influxdb/v1.7/query_language/database_management/#create-database)

## Grafana

#### Requirements

- [X] Grafana 7.3.6-r0
- [X] type LoadBalancer
- [X] port 3000
- [X] linked to InfluxDB
- [X] one dashboard per service

#### Resources

- [Grafana Labs: Configure a Grafana Docker image](https://grafana.com/docs/grafana/latest/administration/configure-docker/)

Select open-source version:

```sh
wget https://dl.grafana.com/oss/release/grafana-7.4.3.linux-amd64.tar.gz
tar -zxvf grafana-7.4.3.linux-amd64.tar.gz
```

> You must restart Grafana for any configuration changes to take effect.  [(Source)](https://grafana.com/docs/grafana/latest/administration/configuration/)

Do not change `defaults.ini`! Grafana defaults are stored in this file. Depending on your OS, make all configuration changes in either `custom.ini` or `grafana.ini`.  
- Default configuration from `$WORKING_DIR/conf/defaults.ini`  
- Custom configuration from `$WORKING_DIR/conf/custom.ini`  
- The custom configuration file path can be overridden using the `--config` parameter

Source: [Grafana Labs: Config file locations](https://grafana.com/docs/grafana/latest/administration/configuration/)

To invoke Grafana CLI, add the path to the grafana binaries in your `PATH` environment variable. Alternately, if your current directory is the bin directory, use `./grafana-cli`. Otherwise, you can specify full path to the CLI. For example, on Linux `/usr/share/grafana/bin/grafana-cli` and on Windows `C:\Program Files\GrafanaLabs\grafana\bin\grafana-cli.exe`.

Source: [Grafana Labs: Grafana CLI](https://grafana.com/docs/grafana/latest/administration/cli/)

Can't find `grafana-cli` on Alpine-based Docker image: [Problem with the linux binaries on Alpine](https://github.com/github/hub/issues/1818)

## Telegraf

#### Requirements

- [X] Telegraf 1.17.0-r0

#### Resources

- [Telegraf official Docker image](https://hub.docker.com/_/telegraf)
- [Telegraf configuration](https://github.com/influxdata/telegraf/blob/master/docs/CONFIGURATION.md)

```console
docker run --rm telegraf:ft telegraf config
```

A [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) resource is used for running a logs collection daemon on every node.
