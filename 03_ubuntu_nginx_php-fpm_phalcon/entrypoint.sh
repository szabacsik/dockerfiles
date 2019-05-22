#!/bin/bash
mkdir -p /home/worker/volume/app/current/public
if [ ! -f /home/worker/volume/app/current/public/index.php ]; then
    echo -e "<?php\n\tphpinfo();" > /home/worker/volume/app/current/public/index.php
fi
mkdir -p /home/worker/volume/logs/supervisord/child
mkdir -p /home/worker/volume/logs/php-fpm
mkdir -p /home/worker/volume/logs/nginx
mkdir -p /home/worker/volume/run
chown worker:worker /home/worker -R
chmod 700 /home/worker
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
