FROM php:7.1-fpm

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
        libmcrypt-dev \
        libpng-dev \
        libxslt-dev \
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
        gd \
        iconv \
        intl \
        mbstring \
        mcrypt \
        opcache \
        pdo_mysql \
        soap \
        xsl \
        zip && \
    perl -pi -e "s/mailhub=mail/mailhub=maildev/" /etc/ssmtp/ssmtp.conf && \
    ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/ && \
    rm -rf /var/lib/apt/lists/*

# Install Imagick, Xdebug and Redis
RUN pecl install imagick && \
    pecl install xdebug && \
    pecl install redis && \
    docker-php-ext-enable imagick xdebug redis

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Use prestissimo to speed up builds
RUN composer global require hirak/prestissimo --prefer-dist --no-progress --no-suggest --optimize-autoloader --classmap-authoritative  --no-interaction

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get install -y nodejs

# Install Grunt CLI
RUN npm install -g grunt-cli

# Install custom PHP configuration
COPY custom.ini /usr/local/etc/php/conf.d/

RUN usermod -u 1000 www-data
