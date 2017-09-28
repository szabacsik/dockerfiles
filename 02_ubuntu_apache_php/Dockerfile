FROM ubuntu:xenial
LABEL maintainer "András Szabácsik <https://github.com/szabacsik>"
ENV TERM=xterm \
    DEBIAN_FRONTEND=noninteractive \
	APACHE_RUN_USER=www-data \
	APACHE_RUN_GROUP=www-data \
	APACHE_LOG_DIR=/var/log/apache2 \
	APACHE_PID_FILE=/var/run/apache2.pid \
	APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_LOCK_DIR=/var/lock/apache2
RUN apt-get update && \
    apt-get install -y --assume-yes --no-install-recommends apt-utils && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
	apt-get install -y --assume-yes --no-install-recommends mc nano git curl net-tools htop screen byobu sudo apache2 && \
	apt-get clean && \
	apt-get autoclean && \
	apt-get autoremove && \
	echo 'ServerName localhost' >> /etc/apache2/apache2.conf && \
	sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.pl index.py index.cgi index.xhtml index.html index.htm/g' /etc/apache2/mods-enabled/dir.conf && \
 	sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2 && \
 	mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR && \
	sudo chown -R www-data: $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR -R
ENV DEBIAN_FRONTEND=teletype
EXPOSE 80
EXPOSE 443
USER www-data:www-data
CMD apachectl -D FOREGROUND