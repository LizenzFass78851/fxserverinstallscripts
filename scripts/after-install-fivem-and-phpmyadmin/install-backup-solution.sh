#!/bin/bash


# script
cd ~
cd server


mkdir backup
cd backup

mkdir fivem
mkdir fivem-mount

mkdir fivem-db
mkdir fivem-db-mount

wget https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/backup-solution/README.md

apt update && apt install borgbackup -y

borg init ~/server/backup/fivem --encryption none -v
borg init ~/server/backup/fivem-db --encryption none -v

wget https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/backup-solution/fivem-backup.sh
wget https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/backup-solution/fivem-db-backup.sh
chmod +x fivem-backup.sh
chmod +x fivem-db-backup.sh


echo [Unit] >/etc/systemd/system/fivembackup.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivembackup.service
echo Description=start FiveM Backup >>/etc/systemd/system/fivembackup.service
echo  >>/etc/systemd/system/fivembackup.service
echo [Service] >>/etc/systemd/system/fivembackup.service
echo Type=simple >>/etc/systemd/system/fivembackup.service
echo ExecStart=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup/fivem-backup.sh >>/etc/systemd/system/fivembackup.service
echo User=$(whoami) >>/etc/systemd/system/fivembackup.service
echo Group=$(whoami) >>/etc/systemd/system/fivembackup.service
echo WorkingDirectory=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup >>/etc/systemd/system/fivembackup.service
echo  >>/etc/systemd/system/fivembackup.service
echo [Install] >>/etc/systemd/system/fivembackup.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivembackup.service
echo WantedBy=multi-user.target >>/etc/systemd/system/fivembackup.service

echo [Unit] >/etc/systemd/system/fivemdbbackup.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemdbbackup.service
echo Description=start FiveM DB Backup >>/etc/systemd/system/fivemdbbackup.service
echo  >>/etc/systemd/system/fivemdbbackup.service
echo [Service] >>/etc/systemd/system/fivemdbbackup.service
echo Type=simple >>/etc/systemd/system/fivemdbbackup.service
echo ExecStart=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup/fivem-db-backup.sh >>/etc/systemd/system/fivemdbbackup.service
echo User=$(whoami) >>/etc/systemd/system/fivemdbbackup.service
echo Group=$(whoami) >>/etc/systemd/system/fivemdbbackup.service
echo WorkingDirectory=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/backup >>/etc/systemd/system/fivemdbbackup.service
echo  >>/etc/systemd/system/fivemdbbackup.service
echo [Install] >>/etc/systemd/system/fivemdbbackup.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemdbbackup.service
echo WantedBy=multi-user.target >>/etc/systemd/system/fivemdbbackup.service

systemctl enable fivembackup.service
systemctl start fivembackup.service

systemctl enable fivemdbbackup.service
systemctl start fivemdbbackup.service

echo "systemctl status fivembackup.service" can be used to query the status of the service
echo "systemctl status fivemdbbackup.service" can be used to query the status of the service
