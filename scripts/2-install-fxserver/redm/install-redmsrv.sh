#!/bin/bash

set -e # Exit the script on error

SRV_ADR="https://runtime.redm.net/artifacts/redm/build_proot_linux/master/"

# for recommended versions
#DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | tail -n -2 | head -n -1 | cut -d '"' -f 2 | cut -c 2-)"

# for newer versions (experimental code to download the newer versions)
DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | head -n 31 | tail -n 1 | cut -d '"' -f 4 | cut -c 2-)"

# script
INSTALL_DIR=~/server/redm
TXDATA_DIR=/txData_rdr2
SERVICE_FILE=/etc/systemd/system/redmserver.service

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
Description=RedM Server

[Service]
Type=simple
ExecStart=${INSTALL_DIR}/run.sh +set serverProfile dev_server +set txAdminPort 40135
User=$(whoami)
Group=$(whoami)
WorkingDirectory=${INSTALL_DIR}

[Install]
# Abschnitt wird im Artikel systemd/Units beschrieben
WantedBy=multi-user.target
EOL

systemctl enable redmserver.service
systemctl start redmserver.service

echo "systemctl status redmserver.service can be used to query the status of the service"
echo "Don't forget to use the command 'chmod -R 777 /txData/' and repeat this if there is data or several users who should help cannot write to it"
