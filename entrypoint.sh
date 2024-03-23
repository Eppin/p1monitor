#!/bin/bash

echo "Creating missing folders"
sudo mkdir -p /var/log/nginx /run/php /var/log/p1monitor

echo "Starting NGINX"
sudo service nginx start

echo "Starting PHP8.2-FPM"
sudo /etc/init.d/php8.2-fpm start

echo "Restore file privileges"
sudo chmod g+w /p1mon/mnt/ramdisk /p1mon/data /var/log/p1monitor

echo "Starting P1Monitor"
/p1mon/scripts/p1mon.sh start

sig_handler () {
  echo "Stop signal received"

  echo "Stopping NGINX"
  sudo service nginx stop

  echo "Stopping PHP8.2-FPM"
  sudo /etc/init.d/php8.2-fpm stop

  /p1mon/scripts/p1mon.sh stop

  exit 0
}

# On signal, stop services
# Find stop signal with `docker inspect ... | grep 'StopSignal'`
trap "sig_handler" SIGINT SIGTERM SIGQUIT

while true; do sleep 1 ; done

exit 0
