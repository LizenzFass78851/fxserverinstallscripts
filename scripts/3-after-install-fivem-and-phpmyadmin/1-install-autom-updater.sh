#!/bin/bash

set -e # Exit the script on error

# script
mkdir -p ~/server/fivem/_autom-updater
cd ~/server/fivem/_autom-updater


wget https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/autom-updater/fivem-updater.sh
chmod +x fivem-updater.sh


echo [Unit] >/etc/systemd/system/fivemupdater.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemupdater.service
echo Description=FiveM Updater >>/etc/systemd/system/fivemupdater.service
echo  >>/etc/systemd/system/fivemupdater.service
echo [Service] >>/etc/systemd/system/fivemupdater.service
echo Type=simple >>/etc/systemd/system/fivemupdater.service
echo ExecStart=$(echo ~)/server/fivem/_autom-updater/fivem-updater.sh >>/etc/systemd/system/fivemupdater.service
echo User=$(whoami) >>/etc/systemd/system/fivemupdater.service
echo Group=$(whoami) >>/etc/systemd/system/fivemupdater.service
echo WorkingDirectory=$(echo ~)/server/fivem/_autom-updater >>/etc/systemd/system/fivemupdater.service
echo  >>/etc/systemd/system/fivemupdater.service
echo [Install] >>/etc/systemd/system/fivemupdater.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemupdater.service
echo WantedBy=multi-user.target >>/etc/systemd/system/fivemupdater.service

systemctl enable fivemupdater.service
systemctl start fivemupdater.service
echo "systemctl status fivemupdater.service" can be used to query the status of the service



