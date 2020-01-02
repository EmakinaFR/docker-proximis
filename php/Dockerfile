FROM php:7.3-fpm-alpine as proximis_php

LABEL maintainer="EmakinaFR <team-proximis@emakina.fr>"

# Install Proximis requirements
RUN \
    apk add --no-cache \
        autoconf \
        automake \
        curl \
        freetype-dev \
        gcc \
        g++ \
        git \
        icu-dev \
        icu-libs \
        imagemagick-dev \
        jq \
        libtool \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libssh2-dev \
        libxml2-dev \
        libxml2-utils \
        libxslt-dev \
        libwebp-dev \
        libzip-dev \
        make \
        msmtp \
        ncurses \
        nodejs-npm \
        openssh-client \
        patch \
        perl \
        shadow \
        ssmtp \
        yarn && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) \
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
    yes "" | pecl install apcu igbinary imagick redis ssh2-1.2 && \
    docker-php-ext-enable apcu igbinary imagick redis ssh2 && \
    perl -pi -e "s/mailhub=mail/mailhub=maildev/" /etc/ssmtp/ssmtp.conf && \
    perl -pi -e "s|;pm.status_path = /status|pm.status_path = /php_fpm_status|g" /usr/local/etc/php-fpm.d/www.conf && \
    yarn global add grunt-cli && \
    apk del .build-deps

# Install Composer globally
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer global require "hirak/prestissimo:dev-master" --no-suggest --optimize-autoloader --classmap-authoritative
ENV PATH "${PATH}:/root/.composer/vendor/bin"

# Install Proximis ComposerProxy
RUN \
    wget https://storage.googleapis.com/omnpackages/composerProxy-linux -O /usr/local/bin/composer-proxy && \
    chmod +x /usr/local/bin/composer-proxy

# Automatically start the SSH agent when a new session is created
RUN echo 'eval $(ssh-agent) && ssh-add' >> /home/www-data/.profile

RUN \
    usermod -u 1000 www-data && \
    groupmod -g 1000 www-data

# Install custom entrypoint
COPY entrypoint.sh /usr/local/bin/docker-custom-entrypoint
RUN chmod 777 /usr/local/bin/docker-custom-entrypoint
CMD ["php-fpm"]
ENTRYPOINT ["docker-custom-entrypoint"]

# ========================================
FROM proximis_php as proximis_php_blackfire
RUN \
    curl -sS https://packages.blackfire.io/binaries/blackfire-php/1.27.1/blackfire-php-alpine_amd64-php-73.so \
        --output $(php -r "echo ini_get('extension_dir');")/blackfire.so && \
    docker-php-ext-enable blackfire
# ========================================

# ========================================
FROM proximis_php as proximis_php_xdebug
RUN \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && \
    yes "" | pecl install xdebug && \
    docker-php-ext-enable xdebug
# ========================================
