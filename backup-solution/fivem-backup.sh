#!/bin/bash
for (( ; ; ))
do
   borg create -v -s -p -C lz4 /$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup/fivem::fivemserver-$(date '+%Y-%m-%d-%H:%M:%S') /txData
   borg prune -v --list --keep-within=4d --keep-daily=7 --keep-weekly=4 --keep-monthly=12 /$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup/fivem 
   sleep 6h
done
