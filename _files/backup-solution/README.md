# borg instructions Linux:
## requires the installed package borgbackup from the selected linux distribution
### all examples can also be applied to the borg repo "fivem-db".

- Create folder as repo (destination storage)
````bash
mkdir -p ~/server/backup/fivem
cd ~/server/backup/fivem
````
- Create repo
````bash
borg init ~/server/backup/fivem --encryption none -v
````
- Create backup
````bash
borg create -v -s -p -C lz4 ~/server/backup/fivem::fivemserver-$(date '+%Y-%m-%d-%H:%M:%S') /txData
````
- Restore Backup
````bash
borg extract -v ~/server/backup/fivem::fivemserver-[SELECTED DATE AND TINE FROM BACKUP LIST without brackets] /txData
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
Description=FiveM Backup

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
[fivem-backup.sh])(./fivem-backup.sh)
````bash
chmod +x ~/server/backup/fivem-backup.sh
````
