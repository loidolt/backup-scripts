#!/bin/sh

# LetsEncrypt Data Backup
sudo gsutil -m rsync -r /etc/letsencrypt/ gs://example-backup/letsencrypt/