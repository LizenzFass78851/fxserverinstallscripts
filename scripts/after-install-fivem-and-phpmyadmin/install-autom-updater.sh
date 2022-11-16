#!/bin/bash


# script
cd ~
cd server


cd fivem


mkdir _autom-updater
cd _autom-updater


wget https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_autom-updater/fivem-updater.sh
chmod +x fivem-updater.sh


echo [Unit] >/etc/systemd/system/fivemupdater.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemupdater.service
echo Description=start FiveM Updater >>/etc/systemd/system/fivemupdater.service
echo  >>/etc/systemd/system/fivemupdater.service
echo [Service] >>/etc/systemd/system/fivemupdater.service
echo Type=simple >>/etc/systemd/system/fivemupdater.service
echo ExecStart=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/fivem/_autom-updater/fivem-updater.sh >>/etc/systemd/system/fivemupdater.service
echo User=$(whoami) >>/etc/systemd/system/fivemupdater.service
echo Group=$(whoami) >>/etc/systemd/system/fivemupdater.service
echo WorkingDirectory=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/fivem/_autom-updater >>/etc/systemd/system/fivemupdater.service
echo  >>/etc/systemd/system/fivemupdater.service
echo [Install] >>/etc/systemd/system/fivemupdater.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemupdater.service
echo WantedBy=multi-user.target >>/etc/systemd/system/fivemupdater.service

systemctl enable fivemupdater.service
systemctl start fivemupdater.service
echo "systemctl status fivemupdater.service" can be used to query the status of the service


# script 2
cd ~
cd server


cd docker


mkdir _autom-updater
cd _autom-updater


wget https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_autom-updater/docker-image-updater.sh
chmod +x docker-image-updater.sh


echo [Unit] >/etc/systemd/system/dockerupdater.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/dockerupdater.service
echo Description=start Docker Image Updater >>/etc/systemd/system/dockerupdater.service
echo  >>/etc/systemd/system/dockerupdater.service
echo [Service] >>/etc/systemd/system/dockerupdater.service
echo Type=simple >>/etc/systemd/system/dockerupdater.service
echo ExecStart=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/docker/_autom-updater/docker-image-updater.sh >>/etc/systemd/system/dockerupdater.service
echo User=$(whoami) >>/etc/systemd/system/dockerupdater.service
echo Group=$(whoami) >>/etc/systemd/system/dockerupdater.service
echo WorkingDirectory=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/docker/_autom-updater >>/etc/systemd/system/dockerupdater.service
echo  >>/etc/systemd/system/dockerupdater.service
echo [Install] >>/etc/systemd/system/dockerupdater.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/dockerupdater.service
echo WantedBy=multi-user.target >>/etc/systemd/system/dockerupdater.service

systemctl enable dockerupdater.service
systemctl start dockerupdater.service
echo "systemctl status dockerupdater.service" can be used to query the status of the service
