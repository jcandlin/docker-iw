FROM ubuntu:xenial
MAINTAINER Jon Candlin jon.candlin@gmail.com

#Install Apache
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apache2 \ 
    && rm -r /var/lib/apt/lists/* 
    
#Add required Apache mods
RUN a2enmod rewrite
RUN a2enmod proxy_http
RUN a2enmod proxy_balancer

#Ensure default Apache configuration is not enabled
RUN unlink /etc/apache2/sites-enabled/000-default.conf

#Copy vhost config into place and enable it
ADD  httpd.conf /etc/apache2/apache2.conf
COPY extra  /etc/apache2/conf-enabled/
#RUN  rm -rf  /etc/apache2/apache2.conf && mv /etc/apache2/httpd.conf /etc/apache2/apache2.conf

#Set Apache environment variables
env APACHE_RUN_USER    root
env APACHE_RUN_GROUP   root
env APACHE_LOG_DIR     /opt/apache/logs
#env APACHE_PID_FILE    /var/run/apache2.pid
#env APACHE_LOCK_DIR    /var/lock/apache2
#env APACHE_SERVERADMIN webmasters@leodis.ac.uk
#env APACHE_SERVERNAME www.leodis.ac.uk

EXPOSE 80

#Start Apache
CMD /usr/sbin/apachectl -D FOREGROUND
