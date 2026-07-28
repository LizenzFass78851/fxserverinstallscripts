#!/bin/bash

set -e # Exit the script on error

SRV_ADR="https://docs.fivem.net/docs/server-download/"

# experimental code to download the version from fivem docs
DL_URL="$(wget -qO- "$SRV_ADR" | grep -oE 'https://downloads\.cfx-services\.net/prod/[^"]+/cfx-server_linux_x64\.tar\.xz' | head -n1)"

# script
INSTALL_DIR=~/server/fivemenhanced
TXDATA_DIR=/txData-fivemenhanced
SERVICE_FILE=/etc/systemd/system/fivemenhancedserver.service

mkdir -p ${INSTALL_DIR}
cd ${INSTALL_DIR}

wget ${DL_URL} -O fx.tar.xz

tar -xvf fx.tar.xz && rm fx.tar.xz

mkdir -p ${TXDATA_DIR}
ln -s -r ${TXDATA_DIR} ./txData
chmod -R 777 ${TXDATA_DIR}

cat <<EOL > ${SERVICE_FILE}
[Unit]
# Abschnitt wird im Artikel systemd/Units beschrieben
Description=FiveM Enhanced Server

[Service]
Type=simple
# Environment definitions: https://github.com/citizenfx/txAdmin/blob/master/docs/env-config.md
#Environment=TXHOST_DATA_PATH=
Environment=TXHOST_TXA_PORT=40126
Environment=TXHOST_FXS_PORT=30121
Environment=TXHOST_GAME_NAME=fivem
Environment=TXHOST_DEFAULT_DBHOST=localhost
Environment=TXHOST_DEFAULT_DBPORT=3306
ExecStart=${INSTALL_DIR}/run.sh
User=$(whoami)
Group=$(whoami)
WorkingDirectory=${INSTALL_DIR}

[Install]
WantedBy=multi-user.target
EOL

systemctl enable fivemenhancedserver.service
systemctl start fivemenhancedserver.service

echo "systemctl status fivemenhancedserver.service can be used to query the status of the service"

if ! getent group team > /dev/null; then
  echo "Creating 'team' group with GID 1600..."
  addgroup --gid 1600 team
else
  if [ "$(getent group team | cut -d: -f3)" -ne 1600 ]; then
    echo "Group 'team' already exists but has a different GID. Please change its GID to 1600 or choose a different group name and update the script accordingly."
    exit 1
  else
    echo "Group 'team' already exists with GID 1600."
  fi
fi

for i in $(seq 1 5); do
  chgrp -R team /txData-fivemenhanced/
  chmod -R 2775 /txData-fivemenhanced/
done

echo "Don't forget to use the command 'chgrp -R team /txData-fivemenhanced/ && chmod -R 2775 /txData-fivemenhanced/' and repeat this if there is data or several users who should help cannot write to it"
echo "Add users to the 'team' group with 'adduser <username> team' to allow them to write to the txData directory"
