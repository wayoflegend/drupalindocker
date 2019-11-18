FROM php:7.2.13-fpm

RUN { \
    echo 'Acquire::http::Pipeline-Depth 0;'; \
    echo 'Acquire::http::No-Cache true;'; \
    echo 'Acquire::BrokenProxy    true;'; \
    } > /etc/apt/apt.conf.d/99fixbadproxy

# install the PHP extensions we need
RUN set -ex; \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections; \
    \
    chmod o+r /etc/resolv.conf; \
    apt-get update; \
    apt-get install -y --fix-missing apt-utils; \
    apt-get install -y --fix-missing libfreetype6-dev; \
    apt-get install -y --fix-missing libjpeg62-turbo-dev; \
    apt-get install -y --fix-missing libpng-dev; \
    apt-get install -y --fix-missing libc-client-dev; \
    apt-get install -y --fix-missing libkrb5-dev; \
    apt-get install -y --fix-missing imagemagick; \
    apt-get install -y --fix-missing ssmtp; \
    apt-get install -y --fix-missing git; \
    apt-get install -y --fix-missing curl; \
    apt-get install -y --fix-missing zip; \
    apt-get install -y --fix-missing unzip; \
    apt-get install -y --fix-missing libmemcachedutil2 libmemcached-dev; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure gd --with-png-dir=/usr/include --with-jpeg-dir=/usr/include; \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install -j$(nproc) gd mysqli opcache pdo_mysql json bcmath zip imap; \
    pecl install -o -f xdebug redis mongodb \
      && rm -rf /tmp/pear \
      && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
      && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini;

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
#RUN { \
#    echo 'opcache.memory_consumption=128'; \
#    echo 'opcache.interned_strings_buffer=8'; \
#    echo 'opcache.max_accelerated_files=4000'; \
#    echo 'opcache.revalidate_freq=2'; \
#    echo 'opcache.fast_shutdown=1'; \
#    echo 'opcache.enable_cli=1'; \
#    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
    echo '[xdebug]'; \
    echo 'xdebug.default_enable = 0'; \
    echo "zend_extension=/usr/local/lib/php/extensions/`ls -t /usr/local/lib/php/extensions | grep no-debug-non-zts-* | head -1`/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini; \
    } >> /usr/local/etc/php/conf.d/xdebug.ini


RUN { \
    echo 'error_reporting  =  E_ALL'; \
    echo 'log_errors = On'; \
    echo 'display_errors = Off'; \
    } > /usr/local/etc/php/php.ini \
# Memcached installation
&& git clone -b php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
&& docker-php-ext-configure /usr/src/php/ext/memcached \
--disable-memcached-sasl \
&& docker-php-ext-install /usr/src/php/ext/memcached \
&& rm -rf /usr/src/php/ext/memcached
# Install Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /usr/local/apache2/htdocs/d8docroot
CMD ["php-fpm"]
EXPOSE 9000