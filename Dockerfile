FROM php:5.6-apache

# This image is Debian Stretch. Its package mirrors and signing keys are archived.
RUN set -eux; \
    rm -rf /etc/apt/sources.list.d; \
    printf '%s\n' 'deb http://archive.debian.org/debian stretch main' > /etc/apt/sources.list; \
    printf '%s\n' \
      'Acquire::Check-Valid-Until "false";' \
      'Acquire::AllowInsecureRepositories "true";' \
      'APT::Get::AllowUnauthenticated "true";' \
      > /etc/apt/apt.conf.d/99archive; \
    apt-get update; \
    apt-get install -y --no-install-recommends --allow-unauthenticated default-libmysqlclient-dev; \
    docker-php-ext-install mysql mysqli pdo_mysql; \
    a2enmod rewrite cgi; \
    rm -rf /var/lib/apt/lists/*

RUN printf '%s\n' \
    'short_open_tag=On' \
    'allow_url_fopen=On' \
    'allow_url_include=On' \
    'display_errors=On' \
    'display_startup_errors=On' \
    'file_uploads=On' \
    'date.timezone=UTC' \
    > /usr/local/etc/php/conf.d/bwapp.ini
