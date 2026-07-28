#!/bin/bash

set -e # Exit the script on error

SRV_ADR="https://docs.fivem.net/docs/server-download/"
SERVER_DIR=~/server/fivemenhanced
DOWNLOAD_FILE=cfx-server_linux_x64.tar.xz
COMPARE_FILE=.compare-buildversion.txt

exiting() {
   echo "Exiting ..."
   exit 0
}

# script
echo "Changing directory to ${SERVER_DIR}"
cd ${SERVER_DIR}

# experimental code to download the version from fivem docs
DL_URL="$(wget -qO- "$SRV_ADR" | grep -oE 'https://downloads\.cfx-services\.net/prod/[^"]+/cfx-server_linux_x64\.tar\.xz' | head -n1)"

build=$(echo "${DL_URL}" | grep -oE '[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}')

if [ -f ./${COMPARE_FILE} ]; then
     last_version=$(cat ./${COMPARE_FILE})
     if [ "${last_version}" == "${build}" ]; then
         echo "No new version available. Current version: ${last_version}. Exiting."
         exiting
     fi
fi

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
         exiting
     fi
fi
   
echo "Stopping FiveM Enhanced service and removing old program files"
systemctl stop fivemenhancedserver.service && rm -rf alpine run.sh

echo "Extracting downloaded file"
tar -xvf "${DOWNLOAD_FILE}" && rm -f "${DOWNLOAD_FILE}"

echo "Starting FiveM Enhanced service"
systemctl start fivemenhancedserver.service

echo "Updating compare file with new version"
echo "${build}" > ./${COMPARE_FILE}

exiting
