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


mkdir redm
cd redm

wget ${DL_URL}

tar -xvf fx.tar.xz
rm fx.tar.xz

echo [Unit] >/etc/systemd/system/redmserver.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/redmserver.service
echo Description=starte RedM Server >>/etc/systemd/system/redmserver.service
echo  >>/etc/systemd/system/redmserver.service
echo [Service] >>/etc/systemd/system/redmserver.service
echo Type=simple >>/etc/systemd/system/redmserver.service
echo ExecStart=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/redm/run.sh +set serverProfile dev_server +set txAdminPort 40125 +set gamename rdr3 >>/etc/systemd/system/redmserver.service
echo User=$(whoami) >>/etc/systemd/system/redmserver.service
echo Group=$(whoami) >>/etc/systemd/system/redmserver.service
echo WorkingDirectory=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/redm >>/etc/systemd/system/redmserver.service
echo  >>/etc/systemd/system/redmserver.service
echo [Install] >>/etc/systemd/system/redmserver.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/redmserver.service
echo WantedBy=multi-user.target >>/etc/systemd/system/redmserver.service

systemctl enable redmserver.service
systemctl start redmserver.service
echo "systemctl status redmserver.service" can be used to query the status of the service
