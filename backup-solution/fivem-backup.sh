#!/bin/bash

BACKUPREPO=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup/fivem
BACKUPDIR=/txData
BACKUPNAME=fivemserver-$(date '+%Y-%m-%d-%H:%M:%S')

echo Breaking the Lock
borg break-lock $BACKUPREPO


for (( ; ; ))
do
   echo Create Backup
   borg create -v -s -p -C lz4 $BACKUPREPO::$BACKUPNAME $BACKUPDIR

   echo Remove Old Backups
   borg prune -v --list --keep-within=4d --keep-daily=7 --keep-weekly=4 --keep-monthly=12 $BACKUPREPO

   echo Waiting for next time to create Backup
   sleep 6h
done
