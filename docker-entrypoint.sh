#!/bin/sh
export ES_JAVA_OPTS="-Xms512m -Xmx512m"
mkdir /run/php-fpm/
chown -R nginx:nginx /elasticsearch
ln -s /data/images /var/www/html/images
ln -s /data/LocalSettings.php /var/www/html/LocalSettings.php
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
# search index data location?
# supervisor d fix
# fix COPY config files