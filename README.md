#Simple php-5 apache2 docker image with composer git and node.js.

##Purpose

* Simple replacement for traditional LAMP stack on linux-based machines.
* An nginx reverse proxy is used to expose dockerized local php5-apache2 content based on domain name/alias.

###How-to build

`docker build -t php5_lamp .`

* or you can use ./buil.sh

###How-to run

`docker run -it -v /path-to-your-www-folder:/var/www/web -v /path-to-your-log-folder:/var/log/apache2 -p 100:80 -d php5_lamp`

* now you can get your instance running on port 100 of you hostt machine

###How-to use it 

Feel free to use any reverse proxy (nginx) or expose port 80 directly to public internet.

Simple example for nginx reverse proxy site:
