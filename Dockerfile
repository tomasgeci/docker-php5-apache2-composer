FROM ubuntu:14.04.3

# inspired by: https://medium.com/dev-tricks/apache-and-php-on-docker-44faef716150
MAINTAINER Tomas Geci <tomas.geci@gmail.com>

RUN apt-get update --fix-missing
RUN apt-get -y upgrade

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5 php5 php5-cli php5-mysql \
php5-gd php5-mcrypt	php5-readline php-pear php-apc php5-apcu php5-curl php5-intl php5-common php5-json \
php-gettext php5-memcached php5-memcache curl lynx-cur node.js git acl

# fix symlink for ubuntu node.js - optional - if node.js is required
# RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install composer
###### RUN bash -c "curl -sS https://getcomposer.org/installer | php mv composer.phar /usr/local/bin/composer"
###### RUN bash -c "wget http://getcomposer.org/composer.phar && mv composer.phar /usr/local/bin/composer"
###### RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
RUN bash -c "curl -sS https://getcomposer.org/installer | php"
RUN bash -c "mv composer.phar /usr/local/bin/composer"

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini

# default timezone for php
RUN echo "date.timezone='Europe/Bratislava'" >> /etc/php5/apache2/php.ini
RUN echo "date.timezone='Europe/Bratislava'" >> /etc/php5/cli/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
RUN php5enmod mcrypt

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND

# set this folder as working for composer,etc...
WORKDIR /var/www/web
