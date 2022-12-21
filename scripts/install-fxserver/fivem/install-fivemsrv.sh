#!/bin/bash

SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"

# for recommended versions
DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | tail -n -2 | head -n -1 | cut -d '"' -f 2 | cut -c 2-)"

# for newer versions (experimental code to download the newer versions)
# DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | head -n 31 | tail -n 1 | cut -d '"' -f 4 | cut -c 2-)"


# script
cd ~
mkdir server
cd server


mkdir fivem
cd fivem

wget ${DL_URL}

tar -xvf fx.tar.xz
rm fx.tar.xz

mkdir /txData
ln -s -r /txData/ ./txData
chmod -R 777 /txData/

echo [Unit] >/etc/systemd/system/fivemserver.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemserver.service
echo Description=starte FiveM Server >>/etc/systemd/system/fivemserver.service
echo  >>/etc/systemd/system/fivemserver.service
echo [Service] >>/etc/systemd/system/fivemserver.service
echo Type=simple >>/etc/systemd/system/fivemserver.service
echo ExecStart=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/fivem/run.sh +set serverProfile dev_server +set txAdminPort 40125 >>/etc/systemd/system/fivemserver.service
echo User=$(whoami) >>/etc/systemd/system/fivemserver.service
echo Group=$(whoami) >>/etc/systemd/system/fivemserver.service
echo WorkingDirectory=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/fivem >>/etc/systemd/system/fivemserver.service
echo  >>/etc/systemd/system/fivemserver.service
echo [Install] >>/etc/systemd/system/fivemserver.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemserver.service
echo WantedBy=multi-user.target >>/etc/systemd/system/fivemserver.service

systemctl enable fivemserver.service
systemctl start fivemserver.service
echo "systemctl status fivemserver.service" can be used to query the status of the service
echo don't forget to use the command "chmod -R 777 /txData/" and repeat this if there is data or several users who should help cannot write to it