# Docker for Proximis [![Build Status](https://travis-ci.org/EmakinaFR/docker-proximis.svg?branch=master)](https://travis-ci.org/EmakinaFR/docker-proximis)

This repository allows the creation of a Docker environment that meets
[Proximis Omnichannel](https://www.proximis.com/) requirements.

## Requirements

- [Docker](https://www.docker.com/)
- [Mutagen](https://mutagen.io/)

## Installation

This process assumes that [Docker Engine](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/) are correctly installed.
Otherwise, you should have a look to the [installation documentation](https://docs.docker.com/install/) before proceeding further. 

### Before installation

The only dependency required to run the environment is [Mutagen](https://mutagen.io/) which will synchronize your local files with docker's containers for maximize performances.
See the [installation documentation](https://mutagen.io/documentation/introduction/installation/) to install it on your system.

On Mac OS, simply run these following commands:

```bash
brew install mutagen-io/mutagen/mutagen
```

If you want that mutagen automatically starts with your system:

```bash
mutagen daemon register
```

You can also start it manually:

```bash
mutagen daemon start
```

### Add the package to development requirements

This Docker environment is available as a Composer package, and thus, can be retrieved like a PHP dependency. To add the environment as a development requirement, just type the following commands inside your project directory.

```bash
# Add the package to your development dependencies
composer require --dev emakinafr/docker-proximis

# Move several configuration files into your project directory
composer exec docker-local-install
```

The second command will copy several files in your project so that you can customize the environment without modifying vendor files.

### Nginx servers

A default Nginx configuration is installed at `docker/local/nginx.conf`. You are free to modify it as you want, to configure your own local domain(s) for instance. 
By default, this configuration use the domain name to retrieve and use the correct configuration file for the `CHANGE_CONFIG_NAME` environment variable.
For example, if your domain app is `proximis-demo-fr.localhost`, the `CHANGE_CONFIG_NAME` value will be `proximis-demo-fr.local`.


### Start the environment

```bash
make env-start
```

**That's all, you're done!** :rocket: 

## Configuration of the Proximis project

This operation can be achieved through the PHP-FPM container.

```bash
make env-php
```

Once in the container, the [official documentation](http://doc.omn.proximis.com/) explains all the remaining steps.

## Environment variables

Multiple environment variables are described inside the `docker/local/.env` file.

### DOCKER_PHP_IMAGE

Defines which image will be used for the `php` container. There are three possible values: `proximis_php` (*default*), `proximis_php_blackfire` or `proximis_php_xdebug`.

### BLACKFIRE_*

Defines the credentials needed to locally profile your application. You'll find more details in the [official documentation](https://blackfire.io/docs/integrations/docker).

### MYSQL_*

Defines the credentials needed to locally setup MySQL server. You'll find more details in the [official documentation](https://store.docker.com/images/mysql#environment-variables).

## Makefile

A [Makefile](https://github.com/EmakinaFR/docker-proximis/blob/master/Makefile) is present in the repository to facilitate the usage of the Docker environment. In order to use it, you have to be in its directory. But as this file is quite useful and since we are often using the same commands all day, it's possible that you have also a `Makefile` in your project.  

To avoid having to move to execute the right file, you can include the Makefile located in your environment directory in the Makefile located inside your project directory.

```
───────┼───────────────────────────────────────────────────────────────────────
       │ File: ~/www/myproject/Makefile
───────┼───────────────────────────────────────────────────────────────────────
   1   │ # Project specific variables
   2   │ DOCKER_PATH := ./vendor/emakinafr/docker-proximis
   3   │ MAKEFILE_DIRECTORY := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
   4   │
   5   │ # Retrieve the Makefile used to manage the Docker environment
   6   │ export COMPOSE_FILE := $(DOCKER_PATH)/docker-compose.yml
   7   │ include $(DOCKER_PATH)/Makefile
   8   │
   9   │ [...]
```

With this structure, you can execute the environment targets like `env-start` or `env-php` directly from your project without adding the environment in your repository.
