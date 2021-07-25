FROM php:7.3-apache-stretch

ENV APP_DIR /var/www/app
ENV APACHE_DOCUMENT_ROOT ${APP_DIR}/web

WORKDIR $APP_DIR

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y libzip-dev libpng-dev mysql-client

RUN docker-php-ext-install bcmath gd mysqli opcache pdo_mysql zip

RUN pecl install -o -f redis && \
  rm -rf /tmp/pear && \
  docker-php-ext-enable redis

# Speed up w/opcache.
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=32531'; \
		echo 'opcache.revalidate_freq=1'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Apache config.
RUN rm -rf /etc/apache2/sites-enabled/*
ADD vhosts/*.conf /etc/apache2/sites-enabled/
RUN sed -i "s#__DOCROOT__#${APACHE_DOCUMENT_ROOT}#g" /etc/apache2/sites-enabled/app.conf && \
    a2enmod rewrite headers && service apache2 restart
