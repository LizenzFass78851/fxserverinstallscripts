#!/bin/bash

SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"

DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | tail -n -2 | head -n -1 | cut -d '"' -f 2 | cut -c 2-)"


# script
cd ~
mkdir server
cd server


mkdir fivem
cd fivem

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
echo # These resources will start by default. >>./server.cfg
echo ensure mapmanager >>./server.cfg
echo ensure chat >>./server.cfg
echo ensure spawnmanager >>./server.cfg
echo ensure sessionmanager >>./server.cfg
echo ensure basic-gamemode >>./server.cfg
echo ensure hardcap >>./server.cfg
echo ensure rconlog >>./server.cfg
echo  >>./server.cfg
echo # This allows players to use scripthook-based plugins such as the legacy Lambda Menu. >>./server.cfg
echo # Set this to 1 to allow scripthook. Do note that this does _not_ guarantee players won't be able to use external plugins. >>./server.cfg
echo sv_scriptHookAllowed 0 >>./server.cfg
echo  >>./server.cfg
echo # Uncomment this and set a password to enable RCON. Make sure to change the password - it should look like rcon_password "YOURPASSWORD" >>./server.cfg
echo #rcon_password "" >>./server.cfg
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
echo # please DO replace root-AQ on the line ABOVE with a real language! :) >>./server.cfg
echo  >>./server.cfg
echo # Set an optional server info and connecting banner image url. >>./server.cfg
echo # Size doesn't matter, any banner sized image will be fine. >>./server.cfg
echo #sets banner_detail "https://url.to/image.png" >>./server.cfg
echo #sets banner_connecting "https://url.to/image.png" >>./server.cfg
echo  >>./server.cfg
echo # Set your server's hostname. This is not usually shown anywhere in listings. >>./server.cfg
echo sv_hostname "FXServer, but unconfigured" >>./server.cfg
echo  >>./server.cfg
echo # Set your server's Project Name >>./server.cfg
echo sets sv_projectName "My FXServer Project" >>./server.cfg
echo  >>./server.cfg
echo # Set your server's Project Description >>./server.cfg
echo sets sv_projectDesc "Default FXServer requiring configuration" >>./server.cfg
echo  >>./server.cfg
echo # Nested configs! >>./server.cfg
echo #exec server_internal.cfg >>./server.cfg
echo  >>./server.cfg
echo # Loading a server icon (96x96 PNG file) >>./server.cfg
echo #load_server_icon myLogo.png >>./server.cfg
echo  >>./server.cfg
echo # convars which can be used in scripts >>./server.cfg
echo set temp_convar "hey world!" >>./server.cfg
echo  >>./server.cfg
echo # Remove the `#` from the below line if you want your server to be listed as 'private' in the server browser. >>./server.cfg
echo # Do not edit it if you *do not* want your server listed as 'private'. >>./server.cfg
echo # Check the following url for more detailed information about this: >>./server.cfg
echo # https://docs.fivem.net/docs/server-manual/server-commands/#sv_master1-newvalue >>./server.cfg
echo #sv_master1 "" >>./server.cfg
echo  >>./server.cfg
echo # Add system admins >>./server.cfg
echo add_ace group.admin command allow # allow all commands >>./server.cfg
echo add_ace group.admin command.quit deny # but don't allow quit >>./server.cfg
echo add_principal identifier.fivem:1 group.admin # add the admin to the group >>./server.cfg
echo  >>./server.cfg
echo # enable OneSync (required for server-side state awareness) >>./server.cfg
echo set onesync on >>./server.cfg
echo  >>./server.cfg
echo # Server player slot limit (see https://fivem.net/server-hosting for limits) >>./server.cfg
echo sv_maxclients 48 >>./server.cfg
echo  >>./server.cfg
echo # Steam Web API key, if you want to use Steam authentication (https://steamcommunity.com/dev/apikey) >>./server.cfg
echo # replace "" with the key >>./server.cfg
echo set steam_webApiKey "" >>./server.cfg
echo  >>./server.cfg
echo # License key for your server (https://keymaster.fivem.net) >>./server.cfg
echo sv_licenseKey changeme >>./server.cfg



echo [Unit] >/etc/systemd/system/fivemserver.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemserver.service
echo Description=starte FiveM Server >>/etc/systemd/system/fivemserver.service
echo >>/etc/systemd/system/fivemserver.service
echo [Service] >>/etc/systemd/system/fivemserver.service
echo Type=simple >>/etc/systemd/system/fivemserver.service
echo ExecStart=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/fivem/run.sh +exec server.cfg >>/etc/systemd/system/fivemserver.service
echo User=$(whoami) >>/etc/systemd/system/fivemserver.service
echo Group=$(whoami) >>/etc/systemd/system/fivemserver.service
echo WorkingDirectory=/$(cd ~ && cd .. && ls | grep "$(whoami)")/server/fivem >>/etc/systemd/system/fivemserver.service
echo >>/etc/systemd/system/fivemserver.service
echo [Install] >>/etc/systemd/system/fivemserver.service
echo # Abschnitt wird im Artikel systemd/Units beschrieben >>/etc/systemd/system/fivemserver.service
echo WantedBy=multi-user.target >>/etc/systemd/system/fivemserver.service

systemctl enable fivemserver.service
systemctl start fivemserver.service
echo "systemctl status fivemserver.service" can be used to query the status of the service
