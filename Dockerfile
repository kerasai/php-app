FROM php:8.0-apache

WORKDIR /code

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y libzip-dev libpng-dev mariadb-client

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

RUN { \
                echo '<VirtualHost *:80>'; \
                echo '    ServerAdmin webmaster@localhost'; \
                echo '    DocumentRoot /var/www/html'; \
                echo '    ServerName localhost'; \
                echo '    <Directory "/var/www/html/">'; \
                echo '		AllowOverride all'; \
                echo '    </Directory>'; \
                echo '</VirtualHost>'; \
        } > /etc/apache2/sites-available/app.conf

RUN a2enmod rewrite headers && a2ensite app && service apache2 restart
