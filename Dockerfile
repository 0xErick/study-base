FROM saqing/node-php-nginx:0.1

## install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

## install pdo_mysql ext
RUN docker-php-ext-install pdo_mysql

## install pcntl ext
RUN docker-php-ext-install pcntl

## install gd ext
RUN apk add --no-cache libpng libpng-dev && docker-php-ext-install gd && apk del libpng-dev

## install zip ext
RUN apk add --no-cache zlib-dev && docker-php-ext-install zip && apk del zlib-dev

## install ldap ext
RUN apk add --no-cache --virtual .persistent-deps \
    ca-certificates \
    openldap-dev \
    curl \
    tar \
    xz \
    && docker-php-ext-configure ldap --with-libdir=lib/ \
    && docker-php-ext-install ldap

## install redis ext
ENV PHPREDIS_VERSION 3.1.6
RUN docker-php-source extract \
    && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && docker-php-ext-install redis \
    && docker-php-source delete

## install mongodb ext
ENV MONGODB_VERSION 1.4.3
RUN docker-php-source extract \
    && curl -L -o /tmp/mongo.tgz  https://pecl.php.net/get/mongodb-$MONGODB_VERSION.tgz \
    && tar zxvf /tmp/mongo.tgz \
    && rm -r /tmp/mongo.tgz \
    && mv mongodb-$MONGODB_VERSION /usr/src/php/ext/mongodb \
    && docker-php-ext-install mongodb \
    && docker-php-source delete

## install tideways ext
RUN docker-php-source extract \
    && curl -L -o /tmp/tideways.tar.gz https://github.com/tideways/php-xhprof-extension/archive/v4.1.7.tar.gz \
    && tar xfz /tmp/tideways.tar.gz \
    && rm -r /tmp/tideways.tar.gz \
    && mv php-xhprof-extension-4.1.7 /usr/src/php/ext/tideways \
    && docker-php-ext-install tideways \
    && docker-php-source delete
## install bcmath ext
RUN docker-php-ext-install bcmath

## install swoole ext
RUN docker-php-source extract \ 
&& curl -L -o /tmp/swoole.tar.gz https://github.com/swoole/swoole-src/archive/v4.2.13.tar.gz \ 
&& tar xfz /tmp/swoole.tar.gz \ 
&& rm -r /tmp/swoole.tar.gz \ 
&& mv swoole-src-4.2.13 /usr/src/php/ext/swoole \ 
&& docker-php-ext-install swoole \ 
&& docker-php-source delete
