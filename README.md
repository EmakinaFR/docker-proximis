# Docker for Proximis [![Build Status](https://travis-ci.org/ajardin/docker-proximis.svg?branch=master)](https://travis-ci.org/ajardin/docker-proximis)
This repository allows the creation of a Docker environment that meets
[Proximis Omnichannel](http://www.proximis.com/solution/proximis-omnichannel/) requirements.

## Architecture
Here are the environment containers:

* `nginx`: This is the Nginx server container (in which the application volume is mounted),
* `php`: This is the PHP-FPM container (in which the application volume is mounted too),
* `mysql`: This is the MariaDB server container,
* `elasticsearch`: This is the Elasticsearch container.

```bash
$ docker-compose ps
          Name                        Command               State                       Ports
------------------------------------------------------------------------------------------------------------------
proximis_elasticsearch_1   /docker-entrypoint.sh elas ...   Up      0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp
proximis_mysql_1           docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp
proximis_nginx_1           nginx -g daemon off;             Up      443/tcp, 0.0.0.0:80->80/tcp
proximis_php_1             php-fpm                          Up      0.0.0.0:9000->9000/tcp
```

## Installation
This process assumes that [Docker Engine](https://www.docker.com/docker-engine),
[Docker Machine](https://docs.docker.com/machine/) and [Docker Compose](https://docs.docker.com/compose/) are installed.
Otherwise, [Docker Toolbox](https://www.docker.com/toolbox) should be installed before proceeding.
The path to the local shared folder is `~/www` by default.

After the installation, the Proximis application is reachable by using [`http://proximis.dev/`](http://proximis.dev/).

### Clone the repository
```bash
$ git clone git@github.com:ajardin/docker-proximis.git
```
It's also possible to download this repository as a
[ZIP archive](https://github.com/ajardin/docker-proximis/archive/master.zip).

### Define the environment variables
```bash
$ cp docker-env.dist docker-env
$ nano docker-env
```
The only mandatory environment variable is: __MYSQL_ROOT_PASSWORD__.

### Create the virtual machine
```bash
$ docker-machine create --driver=virtualbox proximis
$ eval "$(docker-machine env proximis)"
```

### Build the environment
```bash
$ docker-compose up -d
```

### Update the `/etc/hosts` file
```bash
$ docker-machine ip proximis | sudo sh -c 'echo "$(awk {"print $1"})  proximis.dev" >> /etc/hosts'
```
This command add automatically the virtual machine IP address in the `/etc/hosts` file.

### Configuration of the Proximis project
This operation can be achieved through the PHP-FPM container.
```bash
$ docker exec -it proximis_php_1 /bin/bash
```
Once in the container, the [official documentation](http://doc.change-commerce.com/) explains all the remaining steps.

## Custom configuration
The path to the local shared folder can be changed by editing the `docker-compose.yml` file.

It's also possible to automatically define Nginx servers and the PHP configuration. When the environment is built:

* `*.conf` files located under the `nginx` directory are copied to `/etc/nginx/conf.d/`,
* `*.ini` files located under the `php` directory are copied to `/usr/local/etc/php/conf.d/`.
