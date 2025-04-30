#!/bin/bash

set -e # Exit the script on error

RANDOMFOLDER=$RANDOM
GITFOLDERNAME=fxserverinstallscripts-$RANDOMFOLDER
GITFOLDERBRANCH=main
GITREPOLINK=https://github.com/LizenzFass78851/fxserverinstallscripts
BACKUPSOLUTION=1 # 0 = no backup, 1 = backup
FIVEM=1 # 0 = no fivem, 1 = fivem
REDM=0 # 0 = no redm, 1 = redm

apt update && \
  apt install -yy git curl wget

clear

cd /tmp
git clone $GITREPOLINK $GITFOLDERNAME --branch $GITFOLDERBRANCH --depth=1 --single-branch
cd $GITFOLDERNAME

SCRIPTS=$(find $PWD/ \
  | grep ".sh$" \
  | grep "/scripts/" \
  | grep -v "/100-" \
  | { [ $FIVEM -eq 0 ] && grep -v "install-fivemsrv.sh" || cat; } \
  | { [ $REDM -eq 0 ] && grep -v "install-redmsrv.sh" || cat; } \
  | { [ $BACKUPSOLUTION -eq 0 ] && grep -v "backup-solution.sh" || cat; } \
  | grep -v "/without-docker-compose" \
  | sort)

LOGFILE=~/$(date '+%Y-%m-%d-%H:%M:%S')-aio_installscript-vm.log

for SCRIPT in ${SCRIPTS}; do
    echo ============================================================= | tee -a $LOGFILE
    echo RUN $SCRIPT | tee -a $LOGFILE
    chmod +x $SCRIPT
    $SCRIPT 2>&1 | tee -a $LOGFILE
done

rm -rf /tmp/$GITFOLDERNAME
