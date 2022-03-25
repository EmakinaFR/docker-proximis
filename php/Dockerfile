FROM ajardin/php:7.4 as proximis_php

RUN \
  apk add --no-cache autoconf g++ gcc imagemagick-dev ncurses && \
  pecl install igbinary imagick && \
  docker-php-ext-enable igbinary imagick

# ========================================
FROM ajardin/php:7.4-xdebug as proximis_php_xdebug

RUN \
  apk add --no-cache autoconf g++ gcc imagemagick-dev ncurses && \
  pecl install igbinary imagick && \
  docker-php-ext-enable igbinary imagick
