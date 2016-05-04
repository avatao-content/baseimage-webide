FROM avatao/ubuntu:14.04

ENV TERM dumb
ENV NGINX_VERSION 1.8.1-1~trusty

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -qy \
		ca-certificates \
		nginx=${NGINX_VERSION} \ 
		gettext-base \
		php5-fpm \
		php5-sqlite \
		php5-mcrypt \
		php5-mysql \
		supervisor \
		apache2 \			
		libapache2-mod-php5 \
		mariadb-server \
		php-apc \	
		pwgen \
	&& rm -rf /var/lib/apt/lists/* /var/lib/mysql/* \
	&& php5enmod mcrypt

COPY . /

RUN mkdir -p /var/cache/apache2 /var/run/apache2 /var/lock/apache2 /var/log/apache2 /var/run/mysqld /var/log/mysql /var/run/php-fpm \
	&& chown -R user:user /var/cache/apache2 /var/run/apache2 /var/lock/apache2 /var/run/php-fpm  \
	&& chown -R user:user /var/run/mysqld /var/log/mysql /var/lib/mysql \
	&& chown -R user:user /var/www /var/cache/nginx /var/log \
	&& mysql_install_db --defaults-file=/etc/mysql/conf.d/my.cnf \
	&& chmod -R 765 /var/www \
	&& a2ensite site.conf \
	&& a2ensite codiad.conf \
	&& rm /etc/php5/fpm/pool.d/www.conf \
	&& rm /etc/nginx/conf.d/default.conf \
	&& mkdir /etc/nginx/sites-enabled \
	&& ln -s /etc/nginx/sites-available/codiad /etc/nginx/sites-enabled/codiad \
	&& ln -s /etc/nginx/sites-available/server /etc/nginx/sites-enabled/server

EXPOSE 8888

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# THIS IMAGE CONTAINS CODIAD (WITH OR WITHOUT TERMINAL), NGINX, APACHE, MYSQL AND SQLITE
# BUILT IN COMBINATIONS: 
#	- NGINX + PHP-FPM (/etc/supervisor/nginx-php.conf)
#	- APACHE + PHP + MYSQL (/etc/supervisor/apache-mysql.conf)
#	- SQLITE IS INCLUDED BY DEFAULT
# CODIAD DIRECTORY, PORT: /var/www/codiad , 8888
# SERVER DIRECTORY, PORT: /var/www/server , 8008
# PASSWORD IN CODIAD TERMINAL: p
#
# TO DO IN YOUR IMAGE:
#	- CREATE CUSTOM SUPERVISOR CONFIG FILE (IF NEEDED)
#	- CREATE CUSTOM APACHE/NGINX CONFIG FILES (IF NEEDED)
#	- CREATE /opt/db.sql FILE (THIS FILE WILL BE IMPORTED WHEN INITIALIZING MYSQL)
#	- CREATE SERVER FILES (/var/www/server/*.*)
#	- RUN rm <USELESS CONFIG FILES / DIRECTORIES>
#	- RUN cd /var/www \
#		&& patch -p0 -f < /var/www/codiad.patch \
#		-------------- OR /var/www/codiad-terminal.patch (IF YOU NEED TERMINAL IN CODIAD)
#		&& find /var/www/codiad -type f -exec chmod 664 {} +
#	- RUN python3 /opt/setup.py /var/www/server /var/www/server/index.html
#	  (THIS WILL CREATE CODIAD PROJECT WITH GIVEN WORKING DIRECTORY AND FILE TO OPEN AS DEFAULT)
#	- RUN chown -R user:user <EVERYTING YOU NEED TO USE (DOCUMENT ROOT, DB.SQLITE3, ...)>
#	- VOLUME ["/tmp", "/var/log", "<SERVER DOCUMENT ROOT>"]
#	- CODIAD:
#		- VOLUME ["/var/www/codiad/data", "/var/www/codiad/plugins", "/var/www/codiad/themes", "/var/www/codiad/workspace"]
#	- MYSQL:
#		- VOLUME ["/var/lib/mysql", "/var/run/mysqld"]
#	- NGINX + PHP-FPM:
#		- VOLUME ["/var/run/php-fpm", "/var/lib/php5", "/var/cache/nginx", "/run"]
#	- APACHE:
#		- VOLUME ["/var/cache/apache2", "/var/run/apache2", "/var/lock/apache2"]
#	- USER user (NO ROOT ACCESS FOR USERS)
#	- EXPOSE 8008 (IF YOU NEED ANOTHER PORT)
#	- CMD ["supervisord", "-c", "<YOUR SUPERVISOR CONF FILE HERE>"] 
#
# ------ EXAMPLE DOCKERFILE ------
#
# APACHE + MYSQL + CODIAD WITH TERMINAL:
#
# RUN cd /var/www \
#	&& patch -p0 -f < /var/www/codiad-terminal.patch \
#	&& find /var/www/codiad -type f -exec chmod 664 {} + \
#	&& python3 /opt/setup.py /var/www/server /var/www/server/index.php \
#	&& chown -R user:user /var/www
# VOLUME ["/tmp", "/var/log", "/var/www/server"]
# VOLUME ["/var/www/codiad/data", "/var/www/codiad/plugins", "/var/www/codiad/themes", "/var/www/codiad/workspace"]
# VOLUME ["/var/cache/apache2", "/var/run/apache2", "/var/lock/apache2"]
# VOLUME ["/var/lib/mysql", "/var/run/mysqld"]
# USER user
# EXPOSE 8008
# CMD ["supervisord", "-c", "/etc/supervisor/apache-mysql.conf"]

