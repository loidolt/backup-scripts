#!/bin/bash

## Set to run weekly 0 3 * * 0 /usr/local/bin/backup-weekly.sh

SITENAME=example
WEBROOT=/var/www/html/$SITENAME

DBHOST=$(grep DB_HOST $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBUSER=$(grep DB_USER $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBNAME=$(grep DB_NAME $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBPASSWORD=$(grep DB_PASSWORD $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBDUMP=/var/tmp/"$DBNAME"_$(date +"%Y-%m-%d-%H-%M").sql

# Backup Database
mysqldump -h $DBHOST -u $DBUSER -p$DBPASSWORD $DBNAME > $DBDUMP

# Backup Site Files

gsutil -m rsync -r $WEBROOT gs://$SITENAME-backup/$(date +"%Y-%m-%d")/
gsutil -m rsync $DBDUMP gs://$SITENAME-backup/$(date +"%Y-%m-%d")/

# Remove Temporary Files
rm $DBDUMP