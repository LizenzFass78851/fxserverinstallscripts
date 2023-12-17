# borg instructions Linux:
## requires the installed package borgbackup from the selected linux distribution
### all examples can also be applied to the borg repo "fivem-db".

- Create folder as repo (destination storage)
````bash
mkdir ~/server
cd ~/server
mkdir ./backup
cd ./backup
mkdir ./fivem
cd ./fivem
````
- Create repo
````bash
borg init ~/server/backup/fivem --encryption none -v
````
- Create backup
````bash
borg create -v -s -p -C lz4 ~/server/backup/fivem::fivemserver-$(date '+%Y-%m-%d-%H:%M:%S') ~/server/fivem/
````
- Restore Backup
````bash
borg extract -v ~/server/backup/fivem::fivemserver-[SELECTED DATE AND TINE FROM BACKUP LIST without brackets] ~/server/fivem/
````
- Browse backup
````bash
mkdir ~/server/backup/fivem-mount
borg mount -v -f ~/server/backup/fivem::fivemserver-[SELECTED DATE AND TINE FROM BACKUP LIST without brackets] ~/server/backup/fivem-mount
fusermount -u ~/server/backup/fivem-mount #run if -f was not used during mount
````
- Delete backups according to specifications
````bash
borg prune -v --list --keep-within=4d --keep-daily=7 --keep-weekly=4 --keep-monthly=12 ~/server/backup/fivem
````
- List backups
````bash
borg list -v ~/server/backup/fivem
````
- Systemctl template
````bash
nano /etc/systemd/system/fivembackup.service
````
````
[unit]
# Section is described in the systemd/Units article
Description=start FiveM Backup

[Service]
type=simple
ExecStart=/root/server/backup/fivem-backup.sh
User=root
Group=root
WorkingDirectory=/root/server/backup

[Install]
# Section is described in the systemd/Units article
WantedBy=multi-user.target
````
````bash
systemctl enable fivembackup.service
systemctl start fivembackup.service
systemctl status fivembackup.service
````
- example for fivem-backup.sh
````bash
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
````
````bash
chmod +x ~/server/backup/fivem-backup.sh
````
