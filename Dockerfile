FROM php:7.3-fpm

RUN apt-get update -y && apt-get install -y libzip-dev libpng-dev default-mysql-client

RUN docker-php-ext-install bcmath gd mysqli opcache pdo_mysql zip

# Speed up w/opcache.
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=1'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /code
