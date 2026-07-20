#!/bin/bash

set -e # Exit the script on error

install_fivemupdater() {
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
Type=oneshot
ExecStart=$(echo ~)/server/fivem/_autom-updater/fivem-updater.sh
User=$(whoami)
Group=$(whoami)
WorkingDirectory=$(echo ~)/server/fivem/_autom-updater

[Install]
# Section described in the article systemd/Units
WantedBy=multi-user.target
EOF

cat <<EOF >/etc/systemd/system/fivemupdater.timer
[Unit]
Description=Run FiveM Updater

[Timer]
OnCalendar=Mon *-*-* 06:00:00
#OnCalendar=Tue *-*-* 06:00:00
OnCalendar=Wed *-*-* 06:00:00
#OnCalendar=Thu *-*-* 06:00:00
OnCalendar=Fri *-*-* 06:00:00
#OnCalendar=Sat *-*-* 06:00:00
OnCalendar=Sun *-*-* 06:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable and start the service
systemctl enable --now fivemupdater.service fivemupdater.timer

echo "systemctl status fivemupdater.service fivemupdater.timer" can be used to query the status of the service
}

install_redmupdater() {
# Create updater directory
mkdir -p ~/server/redm/_autom-updater
cd ~/server/redm/_autom-updater

# Download and set permissions for updater script
wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/autom-updater/redm-updater.sh
chmod +x redm-updater.sh

# Create systemd service file for updater
cat <<EOF >/etc/systemd/system/redmupdater.service
[Unit]
# Section described in the article systemd/Units
Description=RedM Updater

[Service]
Type=simple
ExecStart=$(echo ~)/server/redm/_autom-updater/redm-updater.sh
User=$(whoami)
Group=$(whoami)
WorkingDirectory=$(echo ~)/server/redm/_autom-updater

[Install]
# Section described in the article systemd/Units
WantedBy=multi-user.target
EOF

cat <<EOF >/etc/systemd/system/redmupdater.timer
[Unit]
Description=Run RedM Updater

[Timer]
OnCalendar=Mon *-*-* 06:00:00
#OnCalendar=Tue *-*-* 06:00:00
OnCalendar=Wed *-*-* 06:00:00
#OnCalendar=Thu *-*-* 06:00:00
OnCalendar=Fri *-*-* 06:00:00
#OnCalendar=Sat *-*-* 06:00:00
OnCalendar=Sun *-*-* 06:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable and start the service
systemctl enable --now redmupdater.service redmupdater.timer

echo "systemctl status redmupdater.service redmupdater.timer" can be used to query the status of the service
}

if [ -d ~/server/fivem ]; then
    install_fivemupdater
else
    echo "FiveM server directory not found. Skipping FiveM updater installation."
fi
if [ -d ~/server/redm ]; then
    install_redmupdater
else
    echo "RedM server directory not found. Skipping RedM updater installation."
fi

echo "Automated updater installation completed."