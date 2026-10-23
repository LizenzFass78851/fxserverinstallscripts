#!/bin/bash

set -e # Exit the script on error

SRV_ADR="https://docs.fivem.net/docs/server-download/"
BUILD_ID="$(wget -qO- "$SRV_ADR" | grep -oE '"buildId":"[^"]+"' | head -n1 | cut -d'"' -f4)"
JSON_URL="https://docs.fivem.net/_next/data/${BUILD_ID}/docs/server-download.json"

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

# Download the latest version from the FiveM server download page
DL_URL="$(wget -qO- "$JSON_URL" | jq -er '.pageProps.legacy.latest.linux[0].downloadURL')"
## tagged version
#DL_URL=https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/37692-ccd92212b96d4633897450940a57dc61dc2bc5b2/fx.tar.xz

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
