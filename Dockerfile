FROM ubuntu:16.04
MAINTAINER Max Ivak <maxivak@gmail.com>


VOLUME ["/var/www"]

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
      apache2 \
      php7.0 \
      php7.0-cli \
      libapache2-mod-php7.0 \
      php-apcu \
      php-xdebug \
      php7.0-gd \
      php7.0-json \
      php7.0-ldap \
      php7.0-mbstring \
      php7.0-mysql \
      php7.0-pgsql \
      php7.0-sqlite3 \
      php7.0-xml \
      php7.0-xsl \
      php7.0-zip \
      php7.0-soap \
      php7.0-opcache \
      php-mysqlnd \
      composer


# pecl
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        autoconf \
        bison \
        libtool \
        flex

RUN apt-get install -y \
        php-dev \
        php-pear

RUN pecl channel-update pecl.php.net
RUN pecl install -f sync-1.1.1


# config

COPY config/apache_default /etc/apache2/sites-available/000-default.conf

COPY config/30-sync.ini /etc/php/7.0/cli/conf.d/30-sync.ini
COPY config/30-sync.ini /etc/php/7.0/apache2/conf.d/30-sync.ini


# run
COPY files/run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

RUN a2enmod rewrite

EXPOSE 80
CMD ["/usr/local/bin/run"]
