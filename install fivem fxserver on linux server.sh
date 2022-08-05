#!/bin/bash

# set this
fivemlink="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/5787-283df723cbd22ff4c8ac1949d6cb8dd397764ce2/fx.tar.xz"


# script
cd ~
mkdir server
cd server


mkdir fivem
cd fivem

for fxlink in ${fivemlink}; do
	wget $fxlink
done

tar -xvf fx.tar.xz
rm fx.tar.xz

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
