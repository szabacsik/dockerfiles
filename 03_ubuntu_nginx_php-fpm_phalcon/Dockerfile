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
	apt-transport-https

#Add worker user
RUN useradd -m -s /bin/bash -U worker -u 1000 && \
    echo worker:worker | chpasswd && \
    usermod -aG www-data worker && \
    echo "worker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

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
    php-json

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
    echo 'extension=psr.so' >> /etc/php/7.3/fpm/php.ini && \
    echo 'extension=psr.so' >> /etc/php/7.3/cli/php.ini

#Install Phalcon Web Framework
RUN curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash && \
	curl -s https://packagecloud.io/install/repositories/phalcon/mainline/script.deb.sh | sudo bash && \
	curl -s https://packagecloud.io/install/repositories/phalcon/mainline/script.deb.sh | sudo bash && \
	apt install -y php7.3-phalcon

#PHP FPM configuration
RUN sed -i -e 's/;emergency_restart_threshold = 0/emergency_restart_threshold = 10/g' /etc/php/7.3/fpm/php-fpm.conf && \
    sed -i -e 's/;emergency_restart_interval = 0/emergency_restart_interval = 1m/g' /etc/php/7.3/fpm/php-fpm.conf

#PHP FPM Pool configuration
RUN sed -i -e 's/user = www-data/user = worker/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/group = www-data/group = worker/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/listen.owner = www-data/listen.owner = worker/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/listen.group = www-data/listen.group = worker/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/pm.max_children = 5/pm.max_children = 51/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/pm.start_servers = 2/pm.start_servers = 3/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/;pm.max_requests = 500/pm.max_requests = 1000/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/;slowlog = log\/\$pool.log.slow/slowlog = \/var\/log\/php7.3-fpm-slow.log/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/;request_slowlog_timeout = 0/request_slowlog_timeout = 5s/g' /etc/php/7.3/fpm/pool.d/www.conf && \
    sed -i -e 's/pid = \/run\/php\/php7.3-fpm.pid/pid = \/home\/worker\/app\/logs\/php7.3-fpm.pid/g' /etc/php/7.3/fpm/php-fpm.conf && \
    sed -i -e 's/error_log = \/var\/log\/php7.3-fpm.log/error_log = \/home\/worker\/app\/logs\/php7.3-fpm.pid/g' /etc/php/7.3/fpm/php-fpm.conf

#NGINX virtual host configuration
RUN mkdir -p /home/worker/app/current/public && \
    mkdir -p /home/worker/app/logs && \
    echo '' > /etc/nginx/sites-available/default  && \
    sed -i -e 's/user www-data;/user worker;/g' /etc/nginx/nginx.conf  && \
    sed -i -e 's/pid \/run\/nginx.pid;/pid \/home\/worker\/app\/logs\/nginx.pid;/g' /etc/nginx/nginx.conf  && \
    sed -i -e 's/access_log \/var\/log\/nginx\/access.log;/access_log \/home\/worker\/app\/logs\/nginx-access.log;/g' /etc/nginx/nginx.conf  && \
    sed -i -e 's/error_log \/var\/log\/nginx\/error.log;/error_log \/home\/worker\/app\/logs\/nginx-error.log;/g' /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf

#Supervisor configuration
RUN mkdir /home/worker/app/logs/supervisord -p
COPY supervisord.conf /etc/supervisor/conf.d/

#Helper scripts
COPY versions.sh /home/worker/

#Finalize and start
RUN chown worker:worker /home/worker -R && \
    chmod -R +rx /home/worker
COPY index.php /home/worker/app/current/public/
EXPOSE 80
EXPOSE 443
EXPOSE 9001
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
