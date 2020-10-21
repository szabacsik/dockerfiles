FROM ubuntu:latest
#Install Software Properties Common
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests software-properties-common
#Install PHP core
RUN add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests php php-dev
# Install Common
RUN apt-get install -y --no-install-recommends --no-install-suggests git make
#Install XDebug
RUN cd /tmp && \
    git clone git://github.com/xdebug/xdebug.git && \
    cd /tmp/xdebug && \
    git checkout 2.9.8 && \
    phpize && \
    ./configure --enable-xdebug && \
    make && \
    make install
RUN grep -qF 'xdebug.so' /etc/php/7.4/apache2/php.ini || echo "\n"zend_extension="$(php-config --extension-dir)/xdebug.so\n" | tee -a /etc/php/7.4/apache2/php.ini
RUN grep -qF 'xdebug.so' /etc/php/7.4/cli/php.ini || echo "\n"zend_extension="$(php-config --extension-dir)/xdebug.so\n" | tee -a /etc/php/7.4/cli/php.ini
RUN echo '\n\nxdebug.remote_port=9000\nxdebug.remote_enable=1\nxdebug.remote_autostart=1\nxdebug.remote_mode=req\nxdebug.remote_host=192.168.88.16\nxdebug.remote_connect_back=0\nxdebug.remote_log=/var/log/xdebug.log' >> /etc/php/7.4/cli/php.ini
WORKDIR /var/www/html
CMD ["sh", "-c", "php -S 0.0.0.0:80"]