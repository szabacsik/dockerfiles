FROM ubuntu:trusty-20160315
LABEL maintainer "szabacsik"
ARG DEBIAN_FRONTEND=noninteractive
RUN DEBIAN_FRONTEND=noninteractive apt-get clean; apt-get autoclean; apt-get autoremove; apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install -y --no-install-recommends mc nano git openssh-server openssl expect curl unzip
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install -y --no-install-recommends apache2=2.4.7-1ubuntu4.13 mysql-server=5.5.55-0ubuntu0.14.04.1 php5=5.5.9+dfsg-1ubuntu4.21 libapache2-mod-php5=5.5.9+dfsg-1ubuntu4.21 php-pear=5.5.9+dfsg-1ubuntu4.21 php5-mysql=5.5.9+dfsg-1ubuntu4.21
RUN ln -sf /bin/bash /bin/sh
RUN groupadd admin -g 1000
RUN useradd admin -d /home/admin -u 1000 -m -s /bin/bash -g admin -p $(echo "123456" | openssl passwd -1 -stdin)
RUN sed -i -e 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i -e 's/bind-address/#bind-address/g' /etc/mysql/my.cnf
RUN sed -i -e 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.pl index.py index.cgi index.xhtml index.html index.htm/g' /etc/apache2/mods-enabled/dir.conf
RUN echo "root:123456" | chpasswd
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR
RUN sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2
RUN sudo chown -R www-data: /var/{log,run,lock}/apache2/
RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf
RUN echo '#!/bin/bash' >> /opt/services.sh
RUN echo 'sudo -H -u www-data apachectl -k start' >> /opt/services.sh
RUN echo '/etc/init.d/ssh start' >> /opt/services.sh
RUN echo '/etc/init.d/mysql start' >> /opt/services.sh
RUN echo '#!/bin/bash' >> /opt/mysql_secure.sh
RUN echo "/usr/bin/expect -c '" >> /opt/mysql_secure.sh
RUN echo 'spawn /usr/bin/mysql_secure_installation' >> /opt/mysql_secure.sh
RUN echo 'expect "Enter current password for root (enter for none):"' >> /opt/mysql_secure.sh
RUN echo 'send "\r"' >> /opt/mysql_secure.sh
RUN echo 'expect "Set root password?"' >> /opt/mysql_secure.sh
RUN echo 'send "y\r"' >> /opt/mysql_secure.sh
RUN echo 'expect "New password:"' >> /opt/mysql_secure.sh
RUN echo 'send "123456\r"' >> /opt/mysql_secure.sh
RUN echo 'expect "Re-enter new password:"' >> /opt/mysql_secure.sh
RUN echo 'send "123456\r"' >> /opt/mysql_secure.sh
RUN echo 'expect "Remove anonymous users?"' >> /opt/mysql_secure.sh
RUN echo 'send "y\r"' >> /opt/mysql_secure.sh
RUN echo 'expect "Disallow root login remotely?"' >> /opt/mysql_secure.sh
RUN echo 'send "n\r"' >> /opt/mysql_secure.sh
RUN echo 'expect "Remove test database and access to it?"' >> /opt/mysql_secure.sh
RUN echo 'send "y\r"' >> /opt/mysql_secure.sh
RUN echo 'expect "Reload privilege tables now?"' >> /opt/mysql_secure.sh
RUN echo 'send "y\r"' >> /opt/mysql_secure.sh
RUN echo 'puts "Ended expect script."' >> /opt/mysql_secure.sh
RUN echo "'" >> /opt/mysql_secure.sh
RUN echo $'mysql --user=root --password=123456 --host=localhost -e "GRANT ALL PRIVILEGES ON *.* TO \'root\'@\'%\' IDENTIFIED BY \'123456\' WITH GRANT OPTION; FLUSH PRIVILEGES;"' >> /opt/mysql_secure.sh
RUN chmod +x /opt/services.sh
RUN chmod +x /opt/mysql_secure.sh
RUN sed -i -e 's/<\/VirtualHost>/Alias \/test "\/var\/www\/test"\n<Directory "\/var\/www\/test">\nallow from all\norder allow,deny\nAllowOverride All\n<\/Directory>\n<\/VirtualHost>\n/g' /etc/apache2/sites-enabled/000-default.conf
RUN mkdir /var/www/test/forks/ezsql -p
RUN curl -sf -o /var/www/test/forks/ezsql/master.zip -LOk https://github.com/ezSQL/ezSQL/archive/master.zip
RUN unzip /var/www/test/forks/ezsql/master.zip -d /var/www/test/forks/ezsql
RUN touch /var/www/test/info.php
RUN echo -e "<?php\nphpinfo();\n?>" > /var/www/test/info.php
COPY database.php /var/www/test/database.php
RUN chown www-data:www-data /var/www -R
RUN usermod -a -G www-data admin
RUN chmod 774 /var/www -R
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install -y --no-install-recommends php5-mcrypt
RUN php5enmod mcrypt
RUN echo '#!/usr/bin/env bash' >> /opt/phpmyadmin_install.sh
RUN echo "PASSWORD='123456'" >> /opt/phpmyadmin_install.sh
RUN echo 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"' >> /opt/phpmyadmin_install.sh
RUN echo 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"' >> /opt/phpmyadmin_install.sh
RUN echo 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"' >> /opt/phpmyadmin_install.sh
RUN echo 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"' >> /opt/phpmyadmin_install.sh
RUN echo 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"' >> /opt/phpmyadmin_install.sh
RUN echo 'sudo apt-get --assume-yes install -y --no-install-recommends phpmyadmin' >> /opt/phpmyadmin_install.sh
RUN chmod +x /opt/phpmyadmin_install.sh
RUN DEBIAN_FRONTEND=noninteractive /bin/bash -c '/opt/services.sh && /opt/mysql_secure.sh && /opt/phpmyadmin_install.sh'
EXPOSE 80 443 22 3306
RUN DEBIAN_FRONTEND=teletype
