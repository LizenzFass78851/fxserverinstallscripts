#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Prevents errors in a pipeline from being masked

echo "Make sure the files to be restored are mounted with borgbackup."
echo "Mount the backup with the following command:"
echo "borg mount -v -f ~/server/backup/fivem::fivemserver-[SELECTED DATE AND TIME FROM BACKUP LIST without brackets] ~/server/backup/fivem-mount"
echo "The example may differ if you want to mount redm or fivem-db."

restore-db() {
  echo "Restoring fivem-db"
  cd ~/server/docker/phpmyadmin
  docker compose down
  rm -rf db
  cp -ra /root/server/backup/fivem-db-mount/root/server/docker/phpmyadmin/db/ .
  docker compose up -d
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

restore-redm() {
  echo "Restoring redm"
  cd ~/server/backup
  systemctl stop redmserver
  rm -rf /txData_rdr2/
  cp -ra fivem-mount/txData_rdr2/ /
  chmod -R 777 /txData_rdr2/
  systemctl start redmserver
  fusermount -u ~/server/backup/redm-mount  # run if -f was not used during mount
}

echo "Select an option:"
echo "1) Restore fivem-db"
echo "2) Restore fivem"
echo "3) Restore redm"
echo "4) Restore all (fivem-db, fivem, redm)"
echo "5) Exit"
read -rp "Enter your choice: " choice

case $choice in
  1)
    restore-db
    ;;
  2)
    restore-fivem
    ;;
  3)
    restore-redm
    ;;
  4)
    restore-db
    restore-fivem
    restore-redm
    ;;
  5)
    echo "Exiting."
    exit 0
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac

echo "Script is done"

