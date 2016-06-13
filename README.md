## THIS IMAGE CONTAINS CODIAD (WITH OR WITHOUT TERMINAL), NGINX, APACHE, MYSQL AND SQLITE

#### BUILT IN COMBINATIONS:

*   NGINX + PHP-FPM (/etc/supervisor/nginx-php.conf)
*   APACHE + PHP + MYSQL (/etc/supervisor/apache-mysql.conf)
*   SQLITE IS INCLUDED BY DEFAULT

**CODIAD DIRECTORY, PORT:** /var/www/codiad , 8888  
**SERVER DIRECTORY, PORT:** /var/www/server , 8008  
**PASSWORD IN CODIAD TERMINAL:** p

**TO DO IN YOUR IMAGE:**

*   CREATE CUSTOM SUPERVISOR CONFIG FILE (IF NEEDED)
*   CREATE CUSTOM APACHE/NGINX CONFIG FILES (IF NEEDED)
*   CREATE /opt/db.sql FILE (THIS FILE WILL BE IMPORTED WHEN INITIALIZING MYSQL)
*   CREATE SERVER FILES (/var/www/server/*.*) 

```
RUN rm <USELESS CONFIG FILES / DIRECTORIES>
RUN cd /var/www \ && patch -p0 -f < /var/www/codiad.patch \
    OR /var/www/codiad-terminal.patch 
    (IF YOU NEED TERMINAL IN CODIAD)  
    && find /var/www/codiad -type f -exec chmod 664 {} +
RUN python3 /opt/setup.py /var/www/server /var/www/server/index.html 
    (THIS WILL CREATE CODIAD PROJECT WITH GIVEN WORKING DIRECTORY AND FILE TO OPEN AS DEFAULT)
RUN chown -R user:user <EVERYTING YOU NEED TO USE (DOCUMENT ROOT, DB.SQLITE3, ...)>
RUN chmod 444 /var/www/codiad/data/projects.php 
VOLUME ["/tmp", "/var/log", "/var/lib/php5", "<SERVER DOCUMENT ROOT>"]
CODIAD: 
    VOLUME ["/var/www/codiad/data", "/var/www/codiad/plugins", 
            "/var/www/codiad/themes", "/var/www/codiad/workspace"]
MYSQL: 
    VOLUME ["/var/lib/mysql", "/var/run/mysqld"]
NGINX + PHP-FPM: 
    VOLUME ["/var/run/php-fpm", "/var/cache/nginx", "/run"]
APACHE: 
    VOLUME ["/var/cache/apache2", "/var/run/apache2", "/var/lock/apache2"]
USER user (NO ROOT ACCESS FOR USERS)
EXPOSE 8008 (IF YOU NEED ANOTHER PORT)
CMD ["supervisord", "-c", "<YOUR SUPERVISOR CONF FILE HERE>"]
```

**EXAMPLE DOCKERFILE**  
**APACHE + MYSQL + CODIAD WITH TERMINAL:**
```
FROM avatao/webide:ubuntu-14.04
RUN cd /var/www \ && patch -p0 -f < /var/www/codiad-terminal.patch \ 
    && find /var/www/codiad -type f -exec chmod 664 {} + \ 
    && python3 /opt/setup.py /var/www/server /var/www/server/index.php \ 
    && chown -R user:user /var/www
VOLUME ["/tmp", "/var/log", "/var/lib/php5", "/var/www/server"]
VOLUME ["/var/www/codiad/data", "/var/www/codiad/plugins", 
        "/var/www/codiad/themes", "/var/www/codiad/workspace"]
VOLUME ["/var/cache/apache2", "/var/run/apache2", "/var/lock/apache2"]
VOLUME ["/var/lib/mysql", "/var/run/mysqld"]
USER user
EXPOSE 8008
CMD ["supervisord", "-c", "/etc/supervisor/apache-mysql.conf"]
