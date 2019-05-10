#!/bin/bash

## Set to run daily 0 3 * * * /usr/local/bin/backup-scripts/backup-database-daily.sh

SITENAME=example
WEBROOT=/var/www/html/$SITENAME

DBHOST=$(grep DB_HOST $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBUSER=$(grep DB_USER $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBNAME=$(grep DB_NAME $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBPASSWORD=$(grep DB_PASSWORD $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBDUMP=/var/tmp/"$DBNAME"_$(date +"%Y-%m-%d-%H-%M").sql

# Backup Database
mysqldump -h $DBHOST -u $DBUSER -p$DBPASSWORD $DBNAME > $DBDUMP

# Send To Google Cloud Storage
gsutil -m cp $DBDUMP gs://$SITENAME-backup/shapshot-database/

# Remove Temporary Files
rm $DBDUMP