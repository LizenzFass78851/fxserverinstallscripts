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

SCRIPTS=$(find  $PWD/ | grep ".sh$" | grep "/scripts/" | grep -v "/100-" | grep -v "/docker-compose" | sort)

for SCRIPT in ${SCRIPTS}; do
        echo =============================================================
	echo RUN $SCRIPT
        chmod +x $SCRIPT
	$SCRIPT
done

rm -rf /tmp/$GITFOLDERNAME
