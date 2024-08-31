#!/bin/bash

echo restore fivem-db
cd ~/server/docker/phpmyadmin && docker-compose down && rm -r db && cp /root/server/backup/fivem-db-mount/root/server/docker/phpmyadmin/db/ -r . && chmod -R 777 db && docker-compose up -d && fusermount -u ~/server/backup/fivem-db-mount #run if -f was not used during mount

#echo restore fivem
#cd ~/server/backup && systemctl stop fivemserver && rm -r /txData/ && cp fivem-mount/txData/ -r / && chmod -R 777 /txData/ && systemctl start fivemserver && fusermount -u ~/server/backup/fivem-mount #run if -f was not used during mount

echo script is done

