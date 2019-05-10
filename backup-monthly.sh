#!/bin/bash

## Set to run monthly 0 3 1 * * /usr/local/bin/backup-scripts/backup-monthly.sh

SITENAME=example
WEBROOT=/var/www/html/$SITENAME

DBHOST=$(grep DB_HOST $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBUSER=$(grep DB_USER $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBNAME=$(grep DB_NAME $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBPASSWORD=$(grep DB_PASSWORD $WEBROOT/public/wp-config.php | awk -F\' '{print$4}')
DBDUMP=/var/tmp/"$DBNAME"_$(date +"%Y-%m-%d-%H-%M").sql

# Backup Database
mysqldump -h $DBHOST -u $DBUSER -p$DBPASSWORD $DBNAME > $DBDUMP

# Backup Site Files and Database to Google Cloud Storage
gsutil -m rsync -r $WEBROOT gs://$SITENAME-backup/$(date +"%Y-%m-%d")/
gsutil -m cp $DBDUMP gs://$SITENAME-backup/$(date +"%Y-%m-%d")/

# Remove Temporary Files
rm $DBDUMP