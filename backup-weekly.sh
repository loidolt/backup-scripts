#!/bin/sh

# Weekly Data Backup
sudo gsutil -m rsync -r /var/www/html/example/ gs://example-backup/weekly/