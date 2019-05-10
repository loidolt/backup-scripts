#!/bin/bash

## Set to run weekly 0 3 * * 0 

SITENAME=example
WEBROOT=/var/www/html/$SITENAME

DBHOST=$(grep DB_HOST $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBUSER=$(grep DB_USER $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBNAME=$(grep DB_NAME $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBPASSWORD=$(grep DB_PASSWORD $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBDUMP="$BKPDIR""$DBNAME"_$(date +"%Y-%m-%d-%H-%M").sql

# Backup Database
mysqldump -h $DBHOST -u $DBUSER -p$DBPASSWORD $DBNAME > $DBDUMP

# Backup Site Files

sudo gsutil -m rsync -zr $WEBROOT gs://$SITENAME-backup/$(date +"%Y-%m-%d")/
sudo gsutil -m rsync -r $DBDUMP gs://$SITENAME-backup/$(date +"%Y-%m-%d")/