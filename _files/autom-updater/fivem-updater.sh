#!/bin/bash

set -e # Exit the script on error

SRV_ADR="https://changelogs-live.fivem.net/api/changelog/versions/linux/server/"
SERVER_DIR=~/server/fivem
DOWNLOAD_FILE=fx.tar.xz
COMPARE_FILE=.compare-buildversion.txt

exiting() {
   echo "Exiting ..."
   exit 0
}

# script
echo "Changing directory to ${SERVER_DIR}"
cd ${SERVER_DIR}

# code to download the version from fivem api
## latest version
DL_URL="$(wget -qO- "$SRV_ADR" | jq -r '.latest_download' | head -n1)"
## recommended version
#DL_URL="$(wget -qO- "$SRV_ADR" | jq -r '.recommended_download' | head -n1)"
## tagged version
#DL_URL=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/9956-41b2e627e3b80ddbba4d63cb74968ac3d5926eb6/fx.tar.xz

[ -z "$DL_URL" ] && { echo "Failed to retrieve download URL. Please check the URL in script or your internet connection."; exit 1; }

build=$(echo "${DL_URL}" | grep -oE '[0-9]+-[^/]+')
[ -z "$build" ] && { echo "Failed to extract build version from download URL."; exit 1; }

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
   
echo "Stopping FiveM service and removing old program files"
systemctl stop fivemserver.service && rm -rf alpine run.sh

echo "Extracting downloaded file"
tar -xvf "${DOWNLOAD_FILE}" && rm -f "${DOWNLOAD_FILE}"

echo "Starting FiveM service"
systemctl start fivemserver.service

echo "Updating compare file with new version"
echo "${build}" > ./${COMPARE_FILE}

exiting
