#!/bin/bash

SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"

DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | tail -n -2 | head -n -1 | cut -d '"' -f 2 | cut -c 2-)"


# script
cd ~
mkdir server
cd server


mkdir redm
cd redm

wget ${DL_URL}

tar -xvf fx.tar.xz
rm fx.tar.xz


wget -qO server-data.zip "http://github.com/citizenfx/cfx-server-data/archive/master.zip"
unzip -q server-data.zip
mv ./cfx-server-data-master/resources ./resources
rm server-data.zip && rm -R cfx-server-data-master/


echo # Only change the IP if you're using a server with multiple network interfaces, otherwise change the port only. >./server.cfg
echo endpoint_add_tcp "0.0.0.0:30120" >>./server.cfg
echo endpoint_add_udp "0.0.0.0:30120" >>./server.cfg
echo  >>./server.cfg
echo ensure spawnmanager >>./server.cfg
echo ensure mapmanager >>./server.cfg
echo ensure basic-gamemode >>./server.cfg
echo  >>./server.cfg
echo # A comma-separated list of tags for your server. >>./server.cfg
echo # For example: >>./server.cfg
echo # - sets tags "drifting, cars, racing" >>./server.cfg
echo # Or: >>./server.cfg
echo # - sets tags "roleplay, military, tanks" >>./server.cfg
echo sets tags "default" >>./server.cfg
echo  >>./server.cfg
echo # A valid locale identifier for your server's primary language. >>./server.cfg
echo # For example "en-US", "fr-CA", "nl-NL", "de-DE", "en-GB", "pt-BR" >>./server.cfg
echo sets locale "root-AQ" >>./server.cfg
echo # please DO replace root-AQ on the line ABOVE with a real language! >>./server.cfg
echo  >>./server.cfg
echo # Set your server's hostname >>./server.cfg
echo sv_hostname "FXServer, but unconfigured" >>./server.cfg
echo  >>./server.cfg
echo # Add system admins >>./server.cfg
echo add_ace group.admin command allow # allow all commands >>./server.cfg
echo add_ace group.admin command.quit deny # but don't allow quit >>./server.cfg
echo add_principal identifier.fivem:1 group.admin # add the admin to the group >>./server.cfg
echo  >>./server.cfg
echo # Hide player endpoints in external log output. >>./server.cfg
echo sv_endpointprivacy true >>./server.cfg
echo  >>./server.cfg
echo # Server player slot limit (must be between 1 and 32, unless using OneSync) >>./server.cfg
echo sv_maxclients 32 >>./server.cfg
echo  >>./server.cfg
echo # Steam Web API key, if you want to use Steam authentication (https://steamcommunity.com/dev/apikey) >>./server.cfg
echo # replace "" with the key >>./server.cfg
echo set steam_webApiKey "" >>./server.cfg
echo  >>./server.cfg
echo # License key for your server (https://keymaster.fivem.net) >>./server.cfg
echo sv_licenseKey changeme >>./server.cfg



echo [Unit] >/etc/systemd/system/redmserver.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/redmserver.service
echo Description=starte RedM Server >>/etc/systemd/system/redmserver.service
echo  >>/etc/systemd/system/redmserver.service
echo [Service] >>/etc/systemd/system/redmserver.service
echo Type=simple >>/etc/systemd/system/redmserver.service
echo ExecStart=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/redm/run.sh +exec server.cfg +set gamename rdr3 >>/etc/systemd/system/redmserver.service
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
