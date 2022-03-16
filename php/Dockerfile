FROM php:7.4-fpm-alpine as proximis_php

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
        npm \
        openssh-client \
        patch \
        perl \
        shadow \
        ssmtp \
        yarn && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp && \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        gd \
        intl \
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
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH "${PATH}:/root/.composer/vendor/bin"

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
FROM ajardin/php:7.4-blackfire as proximis_php_blackfire

RUN \
    version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") && \
    architecture=$(case $(uname -m) in i386 | i686 | x86) echo "i386" ;; x86_64 | amd64) echo "amd64" ;; aarch64 | arm64 | armv8) echo "arm64" ;; *) echo "amd64" ;; esac) && \
    curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s "https://blackfire.io/api/v1/releases/probe/php/alpine/${architecture}/${version}" && \
    mkdir -p /tmp/blackfire && \
    tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire && \
    mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so && \
    rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz && \
    docker-php-ext-enable blackfire
# ========================================

# ========================================
FROM proximis_php as proximis_php_xdebug

RUN \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && \
    yes "" | pecl install xdebug && \
    docker-php-ext-enable xdebug
# ========================================
