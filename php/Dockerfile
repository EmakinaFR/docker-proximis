FROM ajardin/php:7.4 as proximis_php

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    autoconf g++ gcc libmagickwand-dev libmagickcore-dev ncurses-base && \
    pecl install igbinary imagick && \
    docker-php-ext-enable igbinary imagick

# ========================================
FROM ajardin/php:7.4-xdebug as proximis_php_xdebug

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    autoconf g++ gcc libmagickwand-dev libmagickcore-dev ncurses-base && \
    pecl install igbinary imagick && \
    docker-php-ext-enable igbinary imagick
