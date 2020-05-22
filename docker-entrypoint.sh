#!/bin/sh
export ES_JAVA_OPTS="-Xms512m -Xmx512m"
mkdir /run/php-fpm/
chown -R nginx:nginx /elasticsearch
ln -s /data/LocalSettings.php /var/www/html/LocalSettings.php
ln -s /data/images /var/www/html/images
# try and move new install files over if they exist
if [[ -d /var/www/html/azure_install_images ]]
then
    echo "Initial install directory detected. Moving files to appropriate place."
    mv /var/www/html/azure_install_images/. /var/www/html/images
    rm -rf /var/www/html/azure_install_images
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
echo "started services"
# search index data location?
# supervisor d fix
# fix COPY config files