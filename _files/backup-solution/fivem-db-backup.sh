#!/bin/bash

BACKUPREPO=$(echo ~)/server/backup/fivem-db
BACKUPDIR=$(echo ~)/server/docker/phpmyadmin/db

BACKUPNAMEPREFIX=phpmyadmin

KEEPLIST="--keep-within=4d --keep-daily=7 --keep-weekly=4 --keep-monthly=12"
SLEEPTIME=6h

echo Breaking the Lock
borg break-lock $BACKUPREPO || true

while true
do
   echo Create Backup
   if ! borg create -v -s -p -C lz4 $BACKUPREPO::$BACKUPNAMEPREFIX-$(date '+%Y-%m-%d-%H:%M:%S') $BACKUPDIR; then
       echo "Backup creation failed, continuing..."
   fi

   echo Remove Old Backups
   if ! borg prune -v --list $KEEPLIST $BACKUPREPO; then
       echo "Backup pruning failed, continuing..."
   fi

   echo Waiting for next time to create Backup
   sleep $SLEEPTIME
done
