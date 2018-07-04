FROM ubuntu:latest
LABEL maintainer "András Szabácsik <https://github.com/szabacsik>"
ENV TERM=xterm \
    DEBIAN_FRONTEND=noninteractive \
	APACHE_RUN_USER=www-data \
	APACHE_RUN_GROUP=www-data \
	APACHE_LOG_DIR=/var/log/apache2 \
	APACHE_PID_FILE=/var/run/apache2.pid \
	APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_LOCK_DIR=/var/lock/apache2 \
	PHP_INI_SCAN_DIR=/etc/php/7.2/apache2/conf.d:/attached/etc
RUN echo "root:password" | chpasswd
RUN apt-get update
RUN apt-get install -y --assume-yes --no-install-recommends apt-utils
RUN apt-get -y upgrade && \
    apt-get -y dist-upgrade
RUN	apt-get install -y --assume-yes --install-recommends --no-install-suggests man
RUN mkdir /usr/share/man/man1 -p
RUN	apt-get install -y --assume-yes --install-recommends --no-install-suggests mc nano git curl net-tools openssl ca-certificates apt-transport-https htop screen byobu sudo libcap2-bin
RUN apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Budapest /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata
RUN	apt-get install -y --assume-yes --no-install-suggests --install-recommends apache2 && \
	echo 'ServerName localhost' >> /etc/apache2/apache2.conf && \
	sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.pl index.py index.cgi index.xhtml index.html index.htm/g' /etc/apache2/mods-enabled/dir.conf && \
 	sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2 && \
 	mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR && \
	sudo chown -R www-data: $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR -R
RUN apt-get install -y --assume-yes --no-install-suggests --install-recommends php php7.2-mysql php7.2-dev re2c php-mbstring
RUN git clone --depth=1 "git://github.com/phalcon/cphalcon.git" && \
    cd cphalcon/build && \
    sudo ./install
RUN touch /etc/php/7.2/apache2/conf.d/30-phalcon.ini && \
    echo 'extension=phalcon.so' >> /etc/php/7.2/apache2/conf.d/30-phalcon.ini
RUN apachectl -k graceful
RUN apt-get clean && \
	apt-get autoclean && \
	apt-get -y autoremove
RUN a2enmod rewrite
RUN sed -i -e 's/IncludeOptional sites-enabled/# IncludeOptional sites-enabled/g' /etc/apache2/apache2.conf && \
	grep -q -F "IncludeOptional /attached/etc/apache.conf" /etc/apache2/apache2.conf || bash -c 'echo -e "\nIncludeOptional /attached/etc/apache.conf\n" >> /etc/apache2/apache2.conf'
ENV DEBIAN_FRONTEND=teletype
EXPOSE 80
EXPOSE 443
USER www-data:www-data
CMD rm -f /var/run/apache2/* && apachectl -D FOREGROUND
