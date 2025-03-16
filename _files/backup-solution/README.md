# Borg Instructions for Linux

## Requirements
- Install the `borgbackup` package from your selected Linux distribution.

## Examples
All examples can also be applied to the borg repo "fivem-db".

### Create a Folder as Repo (Destination Storage)
```bash
mkdir -p ~/server/backup/fivem
cd ~/server/backup/fivem
```

### Create Repo
```bash
borg init ~/server/backup/fivem --encryption none -v
```

### Create Backup
```bash
borg create -v -s -p -C lz4 ~/server/backup/fivem::fivemserver-$(date '+%Y-%m-%d-%H:%M:%S') /txData
```

### Restore Backup
```bash
borg extract -v ~/server/backup/fivem::fivemserver-[SELECTED DATE AND TIME FROM BACKUP LIST without brackets] /txData
```

### Browse Backup
```bash
mkdir ~/server/backup/fivem-mount
borg mount -v -f ~/server/backup/fivem::fivemserver-[SELECTED DATE AND TIME FROM BACKUP LIST without brackets] ~/server/backup/fivem-mount
fusermount -u ~/server/backup/fivem-mount # Run if -f was not used during mount
```

### Delete Backups According to Specifications
```bash
borg prune -v --list --keep-within=4d --keep-daily=7 --keep-weekly=4 --keep-monthly=12 ~/server/backup/fivem
```

### List Backups
```bash
borg list -v ~/server/backup/fivem
```

### Systemctl Template
```bash
nano /etc/systemd/system/fivembackup.service
```

```ini
[Unit]
Description=FiveM Backup

[Service]
Type=simple
ExecStart=/root/server/backup/fivem-backup.sh
User=root
Group=root
WorkingDirectory=/root/server/backup

[Install]
WantedBy=multi-user.target
```

```bash
systemctl enable fivembackup.service
systemctl start fivembackup.service
systemctl status fivembackup.service
```

### Example for fivem-backup.sh
[fivem-backup.sh](./fivem-backup.sh)
```bash
chmod +x ~/server/backup/fivem-backup.sh
```
