#!/bin/bash

set -e # Exit the script on error

BACKUPREPO=$(echo ~)/server/backup/fivem-db
BACKUPDIR=$(echo ~)/server/docker/phpmyadmin/db

BACKUPNAMEPREFIX=phpmyadmin

KEEPLIST="--keep-within=4d --keep-daily=7 --keep-weekly=4 --keep-monthly=12"
SLEEPTIME=6h

echo Breaking the Lock
borg break-lock $BACKUPREPO


for (( ; ; ))
do
   echo Create Backup
   borg create -v -s -p -C lz4 $BACKUPREPO::$BACKUPNAMEPREFIX-$(date '+%Y-%m-%d-%H:%M:%S') $BACKUPDIR

   echo Remove Old Backups
   borg prune -v --list $KEEPLIST $BACKUPREPO

   echo Waiting for next time to create Backup
   sleep $SLEEPTIME
done
