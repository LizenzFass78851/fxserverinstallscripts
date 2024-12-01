#!/bin/bash

set -e # Exit the script on error

RANDOMFOLDER=$RANDOM
GITFOLDERNAME=fxserverinstallscripts-$RANDOMFOLDER
GITFOLDERBRANCH=main
GITREPOLINK=https://github.com/LizenzFass78851/fxserverinstallscripts

apt update && \
  apt install -yy git curl wget

clear

cd /tmp
git clone $GITREPOLINK $GITFOLDERNAME --branch $GITFOLDERBRANCH --depth=1 --single-branch
cd $GITFOLDERNAME

SCRIPTS=$(find  $PWD/ | grep ".sh$" | grep "/scripts/" | grep -v "/100-" | grep -v "/without-docker-compose" | sort)

LOGFILE=~/$(date '+%Y-%m-%d-%H:%M:%S')-aio_installscript-vm.log

for SCRIPT in ${SCRIPTS}; do
    echo ============================================================= | tee -a $LOGFILE
    echo RUN $SCRIPT | tee -a $LOGFILE
    chmod +x $SCRIPT
    $SCRIPT 2>&1 | tee -a $LOGFILE
done

rm -rf /tmp/$GITFOLDERNAME
