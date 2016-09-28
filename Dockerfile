FROM avatao/ubuntu:16.04

ENV TERM dumb

RUN apt-get update \
	&& apt-get install -qy \
		ca-certificates \
		nginx \ 
		gettext-base \
		php7.0-fpm \
		php7.0 \
		php7.0-sqlite \
		php7.0-mcrypt \
		php7.0-mysql \
		php7.0-mbstring \
		supervisor \
		apache2 \			
		libapache2-mod-php7.0 \
		mariadb-server \	
		pwgen \
	&& rm -rf /var/lib/apt/lists/* /var/lib/mysql/*

COPY . /

RUN mkdir -p /var/cache/apache2 /var/run/apache2 /var/lock/apache2 /var/log/apache2 /var/run/mysqld /var/log/mysql /var/run/php-fpm \
	&& chown -R user:user /var/cache/apache2 /var/run/apache2 /var/lock/apache2 /var/run/php-fpm  \
	&& chown -R user:user /var/run/mysqld /var/log/mysql /var/lib/mysql \
	&& chown -R user:user /var/www /var/log /var/lib/nginx \
	&& mysql_install_db --defaults-file=/etc/mysql/conf.d/my.cnf \
	&& chmod -R 765 /var/www \
	&& a2ensite site.conf \
	&& a2ensite codiad.conf \
	&& ln -s /etc/nginx/sites-available/codiad /etc/nginx/sites-enabled/codiad \
	&& ln -s /etc/nginx/sites-available/server /etc/nginx/sites-enabled/server \
	&& git clone https://github.com/Andr3as/Codiad-CompletePlus.git /var/www/codiad/plugins/completeplus \
	&& cd /var/www \ 
	&& patch -p0 -f < /var/www/codiad.patch \
	&& cp -r /var/www/terminal /var/www/codiad/plugins/terminal \
	&& find /var/www/codiad -type f -exec chmod 664 {} + \
	&& rm -f /etc/nginx/sites-enabled/default \
	&& mkdir /var/cache/nginx \
	&& chown -R user:user /var/cache/nginx \
	&& rm /etc/php/7.0/fpm/pool.d/www.conf

EXPOSE 8888

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
