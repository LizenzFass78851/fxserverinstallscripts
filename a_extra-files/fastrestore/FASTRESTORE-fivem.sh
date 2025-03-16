#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Prevents errors in a pipeline from being masked

restore-db() {
  echo "Restoring fivem-db"
  cd ~/server/docker/phpmyadmin
  docker-compose down
  rm -rf db
  cp -ra /root/server/backup/fivem-db-mount/root/server/docker/phpmyadmin/db/ .
  chmod -R 777 db
  docker-compose up -d
  fusermount -u ~/server/backup/fivem-db-mount  # run if -f was not used during mount
}

restore-fivem() {
  echo "Restoring fivem"
  cd ~/server/backup
  systemctl stop fivemserver
  rm -rf /txData/
  cp -ra fivem-mount/txData/ /
  chmod -R 777 /txData/
  systemctl start fivemserver
  fusermount -u ~/server/backup/fivem-mount  # run if -f was not used during mount
}

#restore-db
restore-fivem

echo "Script is done"

