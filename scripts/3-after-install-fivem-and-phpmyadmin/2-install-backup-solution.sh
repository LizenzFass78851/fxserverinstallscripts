#!/bin/bash

set -e # Exit the script on error

# Create backup directories
mkdir -p ~/server/backup/{fivem,fivem-mount,fivem-db,fivem-db-mount}
cd ~/server/backup

# Download README
wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/backup-solution/README.md

# Install required packages
apt update && apt install -y borgbackup python3-pyfuse3

# Initialize borg repositories
borg init --encryption none -v ~/server/backup/fivem
borg init --encryption none -v ~/server/backup/fivem-db

# Download and set permissions for backup scripts
wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/backup-solution/fivem-backup.sh
wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/backup-solution/fivem-db-backup.sh
chmod +x fivem-backup.sh fivem-db-backup.sh

# Create systemd service files for backups
cat <<EOF >/etc/systemd/system/fivembackup.service
[Unit]
# Section described in the article systemd/Units
Description=FiveM Backup

[Service]
Type=simple
ExecStart=$(echo ~)/server/backup/fivem-backup.sh
User=$(whoami)
Group=$(whoami)
WorkingDirectory=$(echo ~)/server/backup

[Install]
# Section described in the article systemd/Units
WantedBy=multi-user.target
EOF

cat <<EOF >/etc/systemd/system/fivemdbbackup.service
[Unit]
# Section described in the article systemd/Units
Description=FiveM DB Backup

[Service]
Type=simple
ExecStart=$(echo ~)/server/backup/fivem-db-backup.sh
User=$(whoami)
Group=$(whoami)
WorkingDirectory=$(echo ~)/server/backup

[Install]
# Section described in the article systemd/Units
WantedBy=multi-user.target
EOF

# Enable and start the services
systemctl enable --now fivembackup.service
systemctl enable --now fivemdbbackup.service

echo "systemctl status fivembackup.service" can be used to query the status of the service
echo "systemctl status fivemdbbackup.service" can be used to query the status of the service
