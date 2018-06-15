# Docker for Proximis [![Build Status](https://travis-ci.org/EmakinaFR/docker-proximis.svg?branch=master)](https://travis-ci.org/EmakinaFR/docker-proximis)

This repository allows the creation of a Docker environment that meets
[Proximis Omnichannel](https://www.proximis.com/) requirements.

## Architecture

Here are the environment containers:

* `nginx`: [nginx:stable](https://hub.docker.com/_/nginx/) image.
* `php`: [php:7.1-fpm](https://hub.docker.com/_/php/) images.
* `mysql`: [mariadb:latest](https://hub.docker.com/_/mariadb/) image.
* `elasticsearch`: [elasticsearch:5.5.0](https://www.docker.elastic.co/) image.
* `kibana`: [kibana:5.5.3](https://www.docker.elastic.co/) image.
* `logstash`: [logstash:5.5.0](https://www.docker.elastic.co/) image.
* `redis`: [redis:latest](https://hub.docker.com/_/redis/) image.
* `maildev`: [djfarrelly/maildev:latest](https://hub.docker.com/r/djfarrelly/maildev/) image.

## Installation

This process assumes that depending of your OS, [Docker for Mac](https://www.docker.com/products/docker#/mac), [Docker for Windows](https://www.docker.com/products/docker#/windows) or [Docker for linux](https://www.docker.com/products/docker#/linux) is installed.
Otherwise, [Docker Toolbox](https://www.docker.com/toolbox) should be installed before proceeding.

After the installation, the Proximis application is reachable by using [`http://proximis.localhost/`](http://proximis.localhost/).

### Clone the repository

```bash
$ git clone git@github.com:EmakinaFR/docker-proximis.git proximis
```

It's also possible to download this repository as a
[ZIP archive](https://github.com/EmakinaFR/docker-proximis/archive/master.zip).

### Define the environment variables

```bash
$ make env
```

You must set the following environment variables :
 - __WEBSITES__
 - __INTEGRATOR__
 - __MYSQL_ROOT_PASSWORD__

### Start the environment

```bash
$ make install
```

### Check the containers

```bash
$ docker-compose ps
------------------------------------------------------------------------------------------------------------------------
proximis_elasticsearch_1   /docker-entrypoint.sh elas ...   Up      0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp
proximis_kibana_1          /bin/sh -c /usr/local/bin/ ...   Up      0.0.0.0:5601->5601/tcp
proximis_logstash_1        /usr/local/bin/docker-entr ...   Up      0.0.0.0:5000->5000/tcp, 5044/tcp, 9600/tcp
proximis_maildev_1         bin/maildev --web 80 --smtp 25   Up      25/tcp, 0.0.0.0:1080->80/tcp
proximis_mysql_1           docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp
proximis_nginx_1           nginx -g daemon off;             Up      443/tcp, 0.0.0.0:80->80/tcp
proximis_php_1             docker-php-entrypoint php-fpm    Up      9000/tcp
proximis_redis_1           docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp
```

Note: You will see something slightly different if you do not clone the repository in a environment directory. The container prefix depends on your directory name.

### Configuration of the Proximis project

This operation can be achieved through the PHP-FPM container.

```bash
$ docker-compose exec php /bin/bash
```

Once in the container, the [official documentation](http://doc.omn.proximis.com/) explains all the remaining steps.

## Custom configuration

The path to the local shared folder can be changed by editing the variable `WEBSITES` in `.env` file

It's also possible to automatically define Nginx servers, PHP or Redis configuration. When the environment is built:

* `*.conf` files located under the `nginx/site-available` directory are copied to `/etc/nginx/conf.d/`,
* `*.ini` files located under the `php` directory are copied to `/usr/local/etc/php/conf.d/`.
* `redis.conf` file located under the `redis` directory is copied to `/usr/local/etc/redis/`.

## Tips Proximis

### Set up project

Set up your local project with the `project.local.json` file.
 
You mush set the following variable :
 - Change/Mail/username
 - Change/Mail/password
 - Change/Mail/fakemail
 
### Install project

For each command, you will be asked for the name of the project and the name of the client organization

#### Install a new project
```bash
$ make new-project
```

#### Install an existing project
```bash
$ make bootstrap-project
```

#### Update an existing project
```bash
$ make update-project
```