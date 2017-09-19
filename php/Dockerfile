FROM php:7.1-fpm

MAINTAINER Alexandre JARDIN <aja@emakina.fr>
MAINTAINER Thibault DESMOULINS <tds@emakina.fr>
MAINTAINER Romain MONTEIL <rmo@emakina.fr>

COPY *.ini /usr/local/etc/php/conf.d/

RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxslt-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd iconv intl mbstring mcrypt pdo_mysql soap xsl \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y \
        imagemagick \
        graphicsmagick \
        libmagickwand-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/ \
    && yes | pecl install imagick \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/php-ext-imagick.ini \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install redis \
    && pecl install xdebug \
    && docker-php-ext-enable redis xdebug

RUN apt-get update \
    && apt-get install -y \
        curl \
        dnsutils \
        git \
        git-core \
        jq \
        moreutils \
        mysql-client \
        nano \
        netcat \
        net-tools \
        p7zip-full \
        procps \
        telnet \
        unzip \
        vim \
        wget \
        zip \
    && rm -r /var/lib/apt/lists/*

RUN usermod -u 1000 www-data
