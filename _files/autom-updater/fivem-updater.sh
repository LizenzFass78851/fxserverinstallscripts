#!/bin/bash

set -e # Exit the script on error

SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
SERVER_DIR=~/server/fivem
UPDATE_INTERVAL=48h
DOWNLOAD_FILE=fx.tar.xz

while true
do
   # script
   echo "Changing directory to ${SERVER_DIR}"
   cd ${SERVER_DIR}
   
   # for recommended versions
   #DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | tail -n -2 | head -n -1 | cut -d '"' -f 2 | cut -c 2-)"
   # for newer versions (experimental code to download the newer versions)
   DL_URL="${SRV_ADR}$(wget -qO- "$SRV_ADR" | grep -oE 'href="\./[0-9]+-[^/]+/fx\.tar\.xz"' | sed -E 's#href="\./([^"]+)".*#\1#' | sort -t- -k1,1n | tail -n1)"
   # for tagged versions
   #DL_URL=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/9956-41b2e627e3b80ddbba4d63cb74968ac3d5926eb6/fx.tar.xz

   if [ -f ./${DOWNLOAD_FILE} ]; then
        echo "Removing leftover files"
        rm ./${DOWNLOAD_FILE}*
   fi

   echo "Downloading ${DL_URL}"
   wget ${DL_URL} -O "${DOWNLOAD_FILE}"
   if [ ! -f ./${DOWNLOAD_FILE} ]; then
        echo "Waiting 5 seconds before retrying download"
        sleep 5s
        echo "Downloading ${DL_URL} again"
        wget ${DL_URL} -O "${DOWNLOAD_FILE}"
        if [ ! -f ./${DOWNLOAD_FILE} ]; then
            echo "Failed to download ${DL_URL}, exiting"
            exit 1
        fi
   fi
   
   echo "Stopping FiveM service and removing old program files"
   systemctl stop fivemserver.service && rm -rf alpine run.sh
   
   echo "Extracting downloaded file"
   tar -xvf "${DOWNLOAD_FILE}" && rm -f "${DOWNLOAD_FILE}"
   
   echo "Starting FiveM service"
   systemctl start fivemserver.service

   echo "Waiting for next update interval (${UPDATE_INTERVAL})"
   sleep ${UPDATE_INTERVAL}
done
