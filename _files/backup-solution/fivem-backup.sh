#!/bin/bash

BACKUPREPO=$(echo ~)/server/backup/fivem
BACKUPDIR=/txData

BACKUPNAMEPREFIX=fivemserver

KEEPLIST="--keep-within=4d --keep-daily=7 --keep-weekly=4 --keep-monthly=12"

echo Breaking the Lock
borg break-lock $BACKUPREPO || true

echo Create Backup
if ! borg create -v -s -p -C lz4 $BACKUPREPO::$BACKUPNAMEPREFIX-$(date '+%Y-%m-%d-%H:%M:%S') $BACKUPDIR; then
    echo "Backup creation failed, continuing..."
fi

echo Remove Old Backups
if ! borg prune -v --list $KEEPLIST $BACKUPREPO; then
    echo "Backup pruning failed, continuing..."
fi

echo Backup completed successfully
exit 0
