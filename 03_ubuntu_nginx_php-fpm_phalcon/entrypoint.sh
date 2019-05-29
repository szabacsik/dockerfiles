#!/bin/bash
mkdir -p /home/worker/volume/artifact/current/public
if [ ! -f /home/worker/volume/artifact/current/public/index.php ]; then
    echo -e "<?php\n\tphpinfo();" > /home/worker/volume/artifact/current/public/index.php
fi
mkdir -p /home/worker/volume/logs/supervisord/child
mkdir -p /home/worker/volume/logs/php
mkdir -p /home/worker/volume/logs/nginx
mkdir -p /home/worker/volume/run
touch /home/worker/volume/logs/php/fpm-error-stdout-stderr.log
touch /home/worker/volume/logs/php/error.log
touch /home/worker/volume/logs/php/supervisor-php-fpm-stdout.log
touch /home/worker/volume/logs/php/supervisor-php-fpm-stderr.log
touch /home/worker/volume/logs/php/slow.log
chown worker:worker /home/worker -R
chmod 700 /home/worker -R
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
