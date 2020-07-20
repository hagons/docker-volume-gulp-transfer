FROM php:7.3.0
LABEL maintainer="hagon"

# install composer
WORKDIR /root
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
ENV PATH=$PATH:~/.composer/vendor/bin/

# install base
RUN apt-get update -o Acquire::CompressionTypes::Order::=gz && apt-get upgrade -y && apt-get update
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install -y curl zlib1g-dev libzip-dev libpng-dev vim zip unixodbc-dev gnupg2 nodejs
RUN docker-php-ext-install mbstring pdo pdo_mysql opcache zip gd mysqli bcmath
RUN apt-get update && apt-get install -y npm
RUN npm install -g n cross-env npm && n latest

# # install global laravel
# RUN composer global require hirak/prestissimo laravel/laravel laravel/installer

# init root
# ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
# RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
# RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# php debugger
# RUN pecl install -f xdebug sqlsrv pdo_sqlsrv
# RUN docker-php-ext-enable xdebug
# RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
#   && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
#   && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
#   && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
#   && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
#   && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/xdebug.ini

# install driver
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
# RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
# RUN apt-get update
# RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
# RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
# RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools libgssapi-krb5-2
# RUN echo "extension=pdo_sqlsrv.so" >> /usr/local/etc/php/php.ini
# RUN echo "extension=sqlsrv.so" >> /usr/local/etc/php/php.ini

# install project
# COPY ./httpd.conf /etc/httpd/conf
# COPY ./openssl.cnf /etc/ssl
COPY ./reappay_superadmin /var/www/html

WORKDIR /var/www/html
RUN composer install -d /var/www/html
