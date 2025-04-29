#!/bin/bash

set -e # Exit the script on error

install_fivem_backup_solution() {
# Create backup directories
mkdir -p ~/server/backup/{fivem,fivem-mount}
cd ~/server/backup

# Download README
if [ ! -f README.md ]; then
    wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/backup-solution/README.md
fi

# Install required packages
if [ ! -e /bin/borg ]; then
    apt update && apt install -y borgbackup python3-pyfuse3
fi

# Initialize borg repositories
borg init --encryption none -v ~/server/backup/fivem

# Download and set permissions for backup scripts
wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/backup-solution/fivem-backup.sh
chmod +x fivem-backup.sh

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

# Enable and start the services
systemctl enable --now fivembackup.service

echo "systemctl status fivembackup.service" can be used to query the status of the service
}

install_fivem-db_backup_solution() {
# Create backup directories
mkdir -p ~/server/backup/{fivem-db,fivem-db-mount}
cd ~/server/backup

# Download README
if [ ! -f README.md ]; then
    wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/backup-solution/README.md
fi

# Install required packages
if [ ! -e /bin/borg ]; then
    apt update && apt install -y borgbackup python3-pyfuse3
fi

# Initialize borg repositories
borg init --encryption none -v ~/server/backup/fivem-db

# Download and set permissions for backup scripts
wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/backup-solution/fivem-db-backup.sh
chmod +x fivem-db-backup.sh

# Create systemd service files for backups
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
systemctl enable --now fivemdbbackup.service

echo "systemctl status fivemdbbackup.service" can be used to query the status of the service
}

install_redm_backup_solution() {
# Create backup directories
mkdir -p ~/server/backup/{redm,redm-mount}
cd ~/server/backup

# Download README
if [ ! -f README.md ]; then
    wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/backup-solution/README.md
fi

# Install required packages
if [ ! -e /bin/borg ]; then
    apt update && apt install -y borgbackup python3-pyfuse3
fi

# Initialize borg repositories
borg init --encryption none -v ~/server/backup/redm

# Download and set permissions for backup scripts
wget -q https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/backup-solution/redm-backup.sh
chmod +x redm-backup.sh

# Create systemd service files for backups
cat <<EOF >/etc/systemd/system/redmbackup.service
[Unit]
# Section described in the article systemd/Units
Description=RedM Backup

[Service]
Type=simple
ExecStart=$(echo ~)/server/backup/redm-backup.sh
User=$(whoami)
Group=$(whoami)
WorkingDirectory=$(echo ~)/server/backup

[Install]
# Section described in the article systemd/Units
WantedBy=multi-user.target
EOF

# Enable and start the services
systemctl enable --now redmbackup.service

echo "systemctl status redmbackup.service" can be used to query the status of the service
}

if [ -d ~/server/fivem ]; then
    install_fivem_backup_solution
else
    echo "FiveM server directory not found. Skipping FiveM backup-solution installation."
fi

if [ -d ~/server/docker/phpmyadmin ]; then
    install_fivem-db_backup_solution
else
    echo "Docker based phpmyadmin directory not found. Skipping FiveM DB backup-solution installation."
fi

if [ -d ~/server/redm ]; then
    install_redm_backup_solution
else
    echo "RedM server directory not found. Skipping RedM backup-solution installation."
fi

echo "Install Backup Solution installation completed."