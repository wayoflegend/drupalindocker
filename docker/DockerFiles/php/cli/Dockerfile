FROM php:7.2-cli-stretch
# Enabling additional repos
RUN apt-get update -q -y \
&& mkdir /usr/share/man/man1 /usr/share/man/man7 \
&& apt-get install -q -y --no-install-recommends \
ca-certificates \
curl \
acl \
sudo \
# Needed for the php extensions we enable below
libfreetype6 \
libjpeg62-turbo \
libxpm4 \
libpng16-16 \
libicu57 \
libxslt1.1 \
libpng-dev \
libmemcachedutil2 \
# Required if we will enable Drupal imagemagick support:
imagemagick \
# Needed by Drush commands when using Postgresql
postgresql-client \
&& rm -rf /var/lib/apt/lists/*

# Install and configure php plugins
RUN set -xe \
    && buildDeps=" \
        $PHP_EXTRA_BUILD_DEPS \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libxpm-dev \
        libmcrypt-dev \
        libpng-dev \
        libicu-dev \
        libxslt1-dev \
        libmemcached-dev \
        libevent-dev \
        libpq-dev \
        zip \
        unzip \
        software-properties-common \
        ssh-client \
        libsodium-dev \
       git libc-client-dev libkrb5-dev" \
&& apt-get update -q -y \
&& apt-get install -q -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/* \
# Memcached installation
&& git clone -b php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
&& docker-php-ext-configure /usr/src/php/ext/memcached \
--disable-memcached-sasl \
&& docker-php-ext-install /usr/src/php/ext/memcached \
&& rm -rf /usr/src/php/ext/memcached
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
&& docker-php-ext-install imap

# Install Postgre PDO
RUN docker-php-ext-install sodium bcmath imap pdo pdo_mysql pdo_pgsql zip \
&& docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
&& docker-php-ext-enable sodium pdo pdo_mysql pdo_pgsql

# Install Sodium
#RUN pecl install libsodium && \
#echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/libsodium.so" > /usr/local/etc/php/conf.d/ext-sodium.ini

# GD installation
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
# Delete source & builds deps so it does not hang around in layers taking up space
&& rm -Rf "$(pecl config-get temp_dir)/*"

# MongoDb install.
RUN pecl install mongodb \
&& docker-php-ext-enable mongodb bcmath imap gd \
&& docker-php-source delete \
&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
&& apt-get autoremove -y \
&& apt-get clean \
&& rm -r /var/lib/apt/lists/* \
# Global Composer Install
&& cd /tmp/ && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php && php -r "unlink('composer-setup.php');" && chmod +x composer.phar \
&& mv composer.phar /usr/local/bin/composer \
&& echo 'export PATH="./vendor/bin:${PATH}"' >> ~/.bashrc \
&& echo 'export PATH="./vendor/bin:${PATH}"' >> ~/.profile \
&& sed -iE "s/^# alias l=/alias l=/" ~/.bashrc
# Install Drush
RUN composer global require drush/drush && \
    composer global update
# Add global Composer bin directory to PATH
ENV PATH /root/.composer/vendor/bin:$PATH
# PHP sendmail:
RUN curl --location --output /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x /usr/local/bin/mhsendmail
#RUN echo "sendmail_path=/usr/local/bin/mhsendmail --smtp-addr mailhog:1025 " > /usr/local/etc/php/conf.d/sendmail.ini
#RUN echo 'sendmail_path="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025 --from=no-reply@docker.dev"' > /usr/local/etc/php/conf.d/mailhog.ini
