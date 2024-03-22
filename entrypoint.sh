#!/bin/bash

echo "Creating missing folders"
sudo mkdir -p /var/log/nginx /run/php /var/log/p1monitor

echo "Starting NGINX"
sudo service nginx start

echo "Starting PHP8.2-FPM"
sudo /usr/sbin/php-fpm8.2 --fpm-config /etc/php/8.2/fpm/php-fpm.conf 

echo "Restore file privileges"
sudo chmod g+w /p1mon/mnt/ramdisk /p1mon/data /var/log/p1monitor

echo "Starting P1Monitor"
/p1mon/scripts/p1mon.sh start

# On signal, stop services
# Find stop signal with `docker inspect ... | grep 'StopSignal'`
trap "echo Stop signal received; /p1mon/scripts/p1mon.sh stop && exit 0" SIGINT SIGTERM SIGQUIT

while true; do sleep 1 ; done

exit 0
