#!/bin/bash
for (( ; ; ))
do
   # Change workdir
   cd ~/server/docker
   # Mark Runningpoint
   touch _update-is-running.txt
   # Update phpmyadmin
   cd phpmyadmin
   docker-compose pull && docker-compose down && docker-compose up -d
   cd ..
   # Update wg-easy
   cd wg-easy
   docker-compose pull && docker-compose down && docker-compose up -d
   cd ..
   # Build ubuntu-xrdp
   cd ubuntu-xrdp
   docker-compose down && docker rmi ubuntu-xrdp:22.04 && docker-compose up -d
   cd ..
   # Clean Images
   docker image prune --force
   # del Runningpoint
   rm _update-is-running.txt
   sleep 48h
done
