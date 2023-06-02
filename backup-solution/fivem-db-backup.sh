#!/bin/bash
for (( ; ; ))
do
   borg create -v -s -p -C lz4 /$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup/fivem-db::phpmyadmin-$(date '+%Y-%m-%d-%H:%M:%S') /$(cd ~ && cd .. && ls | grep "$(whoami)")/server/docker/phpmyadmin/db
   borg prune -v --list --keep-within=4d --keep-daily=7 --keep-weekly=4 --keep-monthly=12 /$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup/fivem-db
   sleep 6h
done
