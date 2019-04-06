FROM php:7.2-fpm as proximis_php

LABEL maintainer="EmakinaFR <team-proximis@emakina.fr>"

# Install Proximis requirements
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        dnsutils \
        git \
        git-core \
        graphicsmagick \
        gnupg \
        imagemagick \
        jq \
        libzip-dev \
        libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmagickwand-dev \
        libpng-dev \
        libxslt-dev \
        libssh2-1-dev \
        mailutils \
        moreutils \
        mysql-client \
        nano \
        netcat \
        net-tools \
        p7zip-full \
        procps \
        ssh \
        ssmtp \
        telnet \
        unzip \
        vim \
        wget \
        zip && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install \
        bcmath \
        gd \
        iconv \
        intl \
        mbstring \
        opcache \
        pdo_mysql \
        soap \
        xml \
        xsl \
        zip && \
    perl -pi -e "s/mailhub=mail/mailhub=maildev/" /etc/ssmtp/ssmtp.conf && \
    ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/ && \
    rm -rf /var/lib/apt/lists/*

# Install Apcu, Igbinary, Imagick, Redis and ssh2
RUN pecl install apcu igbinary imagick redis ssh2-1.1.2 && \
    docker-php-ext-enable apcu igbinary imagick redis ssh2

# Install Composer globally
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer global require "hirak/prestissimo:dev-master" --no-suggest --optimize-autoloader --classmap-authoritative
ENV PATH "${PATH}:/root/.composer/vendor/bin"

# Install Proxy Composer
RUN wget https://storage.googleapis.com/omnpackages/composerProxy-linux -O /usr/local/bin/composer-proxy && \
    chmod +x /usr/local/bin/composer-proxy

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs

# Install Grunt CLI
RUN npm install -g grunt-cli

# Install Yarn
RUN npm install -g yarn

RUN usermod -u 1000 www-data

# ========================================
FROM proximis_php as proximis_php_blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz
# ========================================

# ========================================
FROM proximis_php as proximis_php_xdebug
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug
# ========================================
