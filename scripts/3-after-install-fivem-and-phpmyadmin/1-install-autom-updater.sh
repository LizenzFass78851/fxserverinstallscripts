#!/bin/bash

set -e # Exit the script on error

# Create updater directory
mkdir -p ~/server/fivem/_autom-updater
cd ~/server/fivem/_autom-updater

# Download and set permissions for updater script
wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/autom-updater/fivem-updater.sh
chmod +x fivem-updater.sh

# Create systemd service file for updater
cat <<EOF >/etc/systemd/system/fivemupdater.service
[Unit]
# Section described in the article systemd/Units
Description=FiveM Updater

[Service]
Type=simple
ExecStart=$(echo ~)/server/fivem/_autom-updater/fivem-updater.sh
User=$(whoami)
Group=$(whoami)
WorkingDirectory=$(echo ~)/server/fivem/_autom-updater

[Install]
# Section described in the article systemd/Units
WantedBy=multi-user.target
EOF

# Enable and start the service
systemctl enable --now fivemupdater.service

echo "systemctl status fivemupdater.service" can be used to query the status of the service



