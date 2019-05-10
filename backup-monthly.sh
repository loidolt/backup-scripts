#!/bin/sh

# Monthly Data Backup
sudo gsutil -m rsync -r /var/www/html/example/ gs://example-backup/monthly/