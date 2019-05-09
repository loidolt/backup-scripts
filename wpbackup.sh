#!/bin/bash

BKPDIR=/local/backup/directory
WEBROOT=/wordpress/install/directory/
SITENAME=example

DBHOST=$(grep DB_HOST $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBUSER=$(grep DB_USER $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBNAME=$(grep DB_NAME $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBPASSWORD=$(grep DB_PASSWORD $WEBROOT/wp-config.php | awk -F\' '{print$4}')
DBDUMP="$BKPDIR""$DBNAME"_$(date +"%Y-%m-%d-%H-%M").sql

#In case you want to rsync backups to remote server
#RUSER=remoteuser
#RHOST=remoteserver
#RDIR=/remote/backup/directory/
#RSSHPORT=22

mysqldump -h $DBHOST -u $DBUSER -p$DBPASSWORD $DBNAME > $DBDUMP

tar -czvf "$BKPDIR"wpbackup_$(date +"%Y-%m-%d_%H-%M").tar.gz $WEBROOT $DBDUMP

#rsync -az $BKPDIR -e "ssh -p $RSSHPORT" $RUSER@$RHOST:$RDIR

gsutil -m rsync -r $BKPDIR gs://$SITENAME-backup/monthly/