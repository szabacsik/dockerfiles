FROM ubuntu:latest
LABEL maintainer="András Szabácsik <https://github.com/szabacsik>"

ENV TERM=xterm \
    DEBIAN_FRONTEND=noninteractive

#System update
RUN apt update && \
    apt upgrade -y && \
    apt full-upgrade

#Install required packages
RUN apt install -y \
	software-properties-common \
	curl \
	sudo \
	git \
	libpcre3-dev \
	apt-transport-https \
	wget \
	zip \
	unzip \
	mysql-client

#Add worker user
RUN useradd -m -s /bin/bash -U worker -u 1000 && \
    echo worker:worker | chpasswd && \
    usermod -aG www-data worker && \
    echo "worker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	mkdir -p /home/worker/volume/artifact/current/public && \
    mkdir -p /home/worker/volume/logs && \
    mkdir -p /home/worker/volume/run

#Add PHP repository
RUN add-apt-repository ppa:ondrej/php && \
    apt update

#Install PHP core
RUN apt install -y \
    php-fpm \
    php-common \
    php-cli \
    php-dev

#Install PHP extensions
RUN apt install -y \
    php-curl \
    php-gd \
    php-json \
    php-mbstring \
    php-zip \
    php7.4-mysql

#Add NGINX repository
RUN add-apt-repository ppa:nginx/stable && \
    apt-get update

#Install NGINX
RUN apt install -y nginx

#Install Supervisor
RUN apt install -y supervisor

#Compile PSR extension from source
RUN cd /tmp && \
    git clone https://github.com/jbboehr/php-psr.git && \
    cd php-psr && \
    phpize && \
    ./configure && \
    make && \
    TEST_PHP_ARGS="-q" make test && \
    make install && \
    echo 'extension=psr.so' >> /etc/php/7.4/fpm/php.ini && \
    echo 'extension=psr.so' >> /etc/php/7.4/cli/php.ini

#Install Phalcon Web Framework
#https://docs.phalconphp.com/4.0/en/installation.html
#https://blog.phalconphp.com/post/phalcon-3-4-3-released
#https://github.com/phalcon/cphalcon/releases/tag/v3.4.3
#https://stackoverflow.com/questions/55942310/install-phalcon-3-4-3-and-getting-4-0-alpha
#RUN curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash && \
#	curl -s https://packagecloud.io/install/repositories/phalcon/mainline/script.deb.sh | sudo bash && \
#	curl -s https://packagecloud.io/install/repositories/phalcon/nightly/script.deb.sh | sudo bash && \
#	apt install -y php7.4-phalcon
RUN git clone --single-branch --branch 4.0.x https://github.com/phalcon/cphalcon.git /tmp/cphalcon
RUN cd /tmp/cphalcon/build && \
    sudo ./install
RUN touch /etc/php/7.4/cli/conf.d/50-phalcon.ini && \
    echo 'extension=phalcon.so' >> /etc/php/7.4/cli/conf.d/50-phalcon.ini && \
    ln -sf /etc/php/7.4/cli/conf.d/50-phalcon.ini /etc/php/7.4/fpm/conf.d/50-phalcon.ini

#PHP error reporting configuration
RUN echo 'display_startup_errors=On' >> /etc/php/7.4/fpm/php.ini && \
    echo 'display_errors=On' >> /etc/php/7.4/fpm/php.ini && \
    echo 'error_reporting=-1' >> /etc/php/7.4/fpm/php.ini && \
    echo 'log_errors=On' >> /etc/php/7.4/fpm/php.ini && \
    echo 'log_errors_max_len=0' >> /etc/php/7.4/fpm/php.ini && \
    echo 'ignore_repeated_errors=On' >> /etc/php/7.4/fpm/php.ini && \
    echo 'error_log=/home/worker/volume/logs/php/error.log' >> /etc/php/7.4/fpm/php.ini

#PHP FPM configuration
RUN sed -i -e 's/;emergency_restart_threshold = 0/emergency_restart_threshold = 10/g' /etc/php/7.4/fpm/php-fpm.conf && \
    sed -i -e 's/;emergency_restart_interval = 0/emergency_restart_interval = 1m/g' /etc/php/7.4/fpm/php-fpm.conf && \
    mkdir -p /home/worker/volume/logs/php && \
    sed -i -e 's/pid = \/run\/php\/php7.4-fpm.pid/pid = \/home\/worker\/volume\/run\/php7.4-fpm.pid/g' /etc/php/7.4/fpm/php-fpm.conf && \
    sed -i -e 's/error_log = \/var\/log\/php7.4-fpm.log/error_log = \/home\/worker\/volume\/logs\/php\/fpm-error-stdout-stderr.log/g' /etc/php/7.4/fpm/php-fpm.conf && \
    sed -i -e 's/;log_level = notice/log_level = notice/g' /etc/php/7.4/fpm/php-fpm.conf && \
    echo 'catch_workers_output = yes' >> /etc/php/7.4/fpm/php-fpm.conf

#PHP FPM Pool configuration
RUN sed -i -e 's/user = www-data/user = worker/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/group = www-data/group = worker/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/listen = \/run\/php\/php7.4-fpm.sock/listen = \/run\/php7.4-fpm.sock/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/listen.owner = www-data/listen.owner = worker/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/listen.group = www-data/listen.group = worker/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/pm.max_children = 5/pm.max_children = 51/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/pm.start_servers = 2/pm.start_servers = 3/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/;pm.max_requests = 500/pm.max_requests = 1000/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/;slowlog = log\/\$pool.log.slow/slowlog = \/home\/worker\/volume\/logs\/php\/slow.log/g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 5s/g' /etc/php/7.4/fpm/pool.d/www.conf

#NGINX virtual host configuration
RUN mkdir -p /home/worker/volume/logs/nginx && \
	echo '' > /etc/nginx/sites-available/default  && \
    sed -i -e 's/user www-data;/user worker;/g' /etc/nginx/nginx.conf  && \
    sed -i -e 's/pid \/run\/nginx.pid;/pid \/home\/worker\/volume\/run\/nginx.pid;/g' /etc/nginx/nginx.conf  && \
    sed -i -e 's/access_log \/var\/log\/nginx\/access.log;/access_log \/home\/worker\/volume\/logs\/nginx\/access.log;/g' /etc/nginx/nginx.conf  && \
    sed -i -e 's/error_log \/var\/log\/nginx\/error.log;/error_log \/home\/worker\/volume\/logs\/nginx\/error.log;/g' /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf

#Supervisor configuration
RUN mkdir /home/worker/volume/logs/supervisord/child -p
COPY supervisord.conf /etc/supervisor/conf.d/

#Install Codeception
RUN curl -LsS https://codeception.com/codecept.phar -o /usr/local/bin/codecept && \
	chmod ugo+x /usr/local/bin/codecept

#Install PHPUnit
RUN curl -LsS https://phar.phpunit.de/phpunit-8.phar -o /usr/local/bin/phpunit && \
	chmod ugo+x /usr/local/bin/phpunit

#Helper scripts
COPY versions.sh /home/worker/
COPY installComposer.sh /home/worker/

#Install Composer
RUN chmod +x /home/worker/installComposer.sh && \
    /bin/bash -c /home/worker/installComposer.sh
RUN mv /composer.phar /usr/local/bin/composer && \
    chmod ugo+x /usr/local/bin/composer

#Finalize and start
RUN chown worker:worker /home/worker -R && \
    chmod -R +rx /home/worker
COPY index.php /home/worker/volume/artifact/current/public/
EXPOSE 80
EXPOSE 443
EXPOSE 9001
COPY entrypoint.sh /home/worker/
RUN chmod +x /home/worker/entrypoint.sh
CMD ["/home/worker/entrypoint.sh"]
