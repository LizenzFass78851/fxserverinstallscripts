# borg instructions Linux:
## requires the installed package borgbackup from the selected linux distribution

- Create folder as repo (destination storage)
````
mkdir ~/server
cd ~/server
mkdir ./backup
cd ./backup
mkdir ./fivem
cd ./fivem
````
- Create repo
````
borg init ~/server/backup/fivem --encryption none -v
````
- Create backup
````
borg create -v -s -p -C lz4 ~/server/backup/fivem::fivemserver-$(date '+%Y-%m-%d-%H:%M:%S') ~/server/fivem/
````
- Restore Backup
````
borg extract -v ~/server/backup/fivem::fivemserver-[PLEASE ENTER THE APPROPRIATE TIME HERE without brackets] ~/server/fivem/
````
- Browse backup
````
mkdir ~/server/backup/fivem-mount
borg mount -v -f ~/server/backup/fivem::fivemserver-[PLEASE ENTER THE APPROPRIATE TIME HERE without brackets] ~/server/backup/fivem-mount
fusermount -u ~/server/backup/fivem-mount #run if -f was not used during mount
````
- Delete backups according to specifications
````
borg prune -v --list --keep-within=1d --keep-daily=7 --keep-weekly=4 --keep-monthly=12 ~/server/backup/fivem
````
- List backups
````
borg list -v ~/server/backup/fivem
````
- Systemctl template
````
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
````
systemctl enable fivembackup.service
systemctl start fivembackup.service
systemctl status fivembackup.service
````
- example for fivem-backup.sh
````
#!/bin/bash
for (( ; ; ))
do
   borg create -v -s -p -C lz4 /$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup/fivem::fivemserver-$(date '+%Y-% m-%d-%H:%M:%S') /$(cd ~ && cd .. && ls | grep "$(whoami)")/server/fivem/
   borg prune -v --list --keep-within=1d --keep-daily=7 --keep-weekly=4 --keep-monthly=12 /$(cd ~ && cd .. && ls | grep "$ (whoami)")/server/backup/fivem
   sleep 24h
done
````
````
chmod +x ~/server/backup/fivem-backup.sh
````
