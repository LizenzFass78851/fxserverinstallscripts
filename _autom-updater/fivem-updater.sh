#!/bin/bash
for (( ; ; ))
do
   SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
   
   # script
   cd ~
   cd server
   cd fivem
   
   
   #DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | head -n 31 | tail -n 1 | cut -d '"' -f 4 | cut -c 2-)"
   #wget ${DL_URL}
   	if [ ! -f ./fx.tar.xz ]; then
   		DL_URL=${SRV_ADR}"$(wget -q -O - ${SRV_ADR} | grep -B 1 'LATEST RECOMMENDED' | tail -n -2 | head -n -1 | cut -d '"' -f 2 | cut -c 2-)";
   		wget ${DL_URL}
   		if [ ! -f ./fx.tar.xz ]; then
   			exit 1;
   		fi
   	fi
   
   
   systemctl stop fivemserver.service
   del -r alpine
   del run.sh
   
   tar -xvf fx.tar.xz
   rm fx.tar.xz
   
   
   systemctl start fivemserver.service
   sleep 48h
done
