#!/bin/bash

set -e # Exit the script on error

SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"

# for recommended versions
#DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | tail -n -2 | head -n -1 | cut -d '"' -f 2 | cut -c 2-)"

# for newer versions (experimental code to download the newer versions)
DL_URL="${SRV_ADR}$(wget -qO- "$SRV_ADR" | grep -oE 'href="\./[0-9]+-[^/]+/fx\.tar\.xz"' | sed -E 's#href="\./([^"]+)".*#\1#' | sort -t- -k1,1n | tail -n1)"

# script
INSTALL_DIR=~/server/fivem
TXDATA_DIR=/txData
SERVICE_FILE=/etc/systemd/system/fivemserver.service

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
Description=FiveM Server

[Service]
Type=simple
# Environment definitions: https://github.com/citizenfx/txAdmin/blob/master/docs/env-config.md
#Environment=TXHOST_DATA_PATH=
Environment=TXHOST_TXA_PORT=40125
Environment=TXHOST_FXS_PORT=30120
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

systemctl enable fivemserver.service
systemctl start fivemserver.service

echo "systemctl status fivemserver.service can be used to query the status of the service"
echo "Don't forget to use the command 'chmod -R 777 /txData/' and repeat this if there is data or several users who should help cannot write to it"
