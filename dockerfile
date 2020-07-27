FROM php:7.3.0-apache
LABEL maintainer="hagon"

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && chmod +x /usr/bin/composer

# install base
RUN apt-get update -o Acquire::CompressionTypes::Order::=gz && apt-get upgrade -y && apt-get update
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y curl zlib1g-dev libzip-dev libpng-dev vim zip unixodbc-dev gnupg2 nodejs npm net-tools ssh
RUN docker-php-ext-install mbstring pdo pdo_mysql opcache zip gd mysqli bcmath
RUN npm install -g n cross-env npm && n latest

# init php root
ARG APACHE_DOCUMENT_ROOT=/var/www/html/public
ENV APACHE_DOCUMENT_ROOT="${APACHE_DOCUMENT_ROOT}"
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# php debugger
RUN pecl install -f xdebug sqlsrv pdo_sqlsrv
RUN docker-php-ext-enable xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
  && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/xdebug.ini

# time
ARG TZ="Asia/Seoul"
ENV TZ="${TZ}"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo "date.timezone = Asia/Seoul" > /usr/local/etc/php/conf.d/timezone.ini

# php file size
ARG UPLOAD_SIZE=10M
ARG POST_SIZE=30M
ENV UPLOAD_SIZE="${UPLOAD_SIZE}"
ENV POST_SIZE="${POST_SIZE}"
RUN touch /usr/local/etc/php/conf.d/uploads.ini \
  && echo "upload_max_filesize = ${UPLOAD_SIZE};" >> /usr/local/etc/php/conf.d/uploads.ini \
  && echo "post_max_size = ${POST_SIZE};" >> /usr/local/etc/php/conf.d/uploads.ini

# php setting
COPY ./httpd.conf /etc/httpd/conf
COPY ./openssl.cnf /etc/ssl
RUN a2enmod rewrite
RUN echo "AddType application/x-httpd-php .php .php3 .htm .html" >> /etc/apache2/apache2.conf

# install project
WORKDIR /var/www/html
COPY ./reappay_superadmin /var/www/html
COPY ./start.sh /start.sh
RUN chmod -R 777 storage

EXPOSE 22
RUN useradd -m local && echo "local:local" | chpasswd && adduser local sudo

ENTRYPOINT [ "bash", "/start.sh" ]