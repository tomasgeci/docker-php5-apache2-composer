#Simple docker container with php5-apache2, composer and git.

##Purpose

* Simple replacement for traditional LAMP stack on linux-based machines.
* An nginx reverse proxy is used to expose dockerized local php5-apache2 content based on domain name/alias.

###How-to build

```docker build -t php5_lamp .```

You can use ./build.sh

###How-to run

```docker run -it -v /path-to-your-www-folder:/var/www/web -v /path-to-your-log-folder:/var/log/apache2 -p 100:80 -d php5_lamp```

* where `path-to-your-www-folder` is your php-based application path and `path-to-your-log-folder` is the place, where you can find apache2 logs

Now you can get your instance running on port 100 of you host machine.

###How-to use it 

Feel free to use any reverse proxy (nginx) or expose port 80 directly to public internet.

Simple example config file for nginx reverse proxy site:


```
# Default server configuration
server {
	listen 80;
	server_name your-host-1 your-host-2 your-host-alias-3;
	root /var/www/html;
       	index index.php index.html;

       location / {
				# port 100 is only example, but should match with docker exposed port in run.sh	
                proxy_pass http://localhost:100;
                include /etc/nginx/proxy_params;
       }	
}
```