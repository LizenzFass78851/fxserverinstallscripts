#!/bin/bash

set -e # Exit the script on error

for (( ; ; ))
do
   SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
   
   # script
   echo change dir
   cd ~/server/fivem
   
   
   #DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | head -n 31 | tail -n 1 | cut -d '"' -f 4 | cut -c 2-)"
   #echo downloading ${DL_URL}
   #wget ${DL_URL}
   	if [ ! -f ./fx.tar.xz ]; then
   		DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | tail -n -2 | head -n -1 | cut -d '"' -f 2 | cut -c 2-)";
   		echo downloading ${DL_URL}
                wget ${DL_URL}
   		if [ ! -f ./fx.tar.xz ]; then
   			exit 1;
   		fi
   	fi
   
   echo stop fivem service and remove old program files
   systemctl stop fivemserver.service
   rm -r alpine
   rm run.sh
   
   echo extract downloaded file
   tar -xvf fx.tar.xz
   rm fx.tar.xz
   
   echo start fivem service
   systemctl start fivemserver.service

   echo Waiting for next time to update fivem
   sleep 48h
done
