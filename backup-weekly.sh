#!/bin/bash

WEBROOT=/var/www/html/
SITENAME=example

DBHOST=$(grep DB_HOST $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBUSER=$(grep DB_USER $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBNAME=$(grep DB_NAME $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBPASSWORD=$(grep DB_PASSWORD $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBDUMP="$BKPDIR""$DBNAME"_$(date +"%Y-%m-%d-%H-%M").sql

# Backup Database
mysqldump -h $DBHOST -u $DBUSER -p$DBPASSWORD $DBNAME > $DBDUMP

# Weekly Data Backup
sudo gsutil -m rsync -r $WEBROOT/$SITENAME gs://$SITENAME-backup/weekly/$(date +"%Y-%m-%d")/
sudo gsutil -m rsync -r $DBDUMP gs://$SITENAME-backup/weekly/$(date +"%Y-%m-%d")/