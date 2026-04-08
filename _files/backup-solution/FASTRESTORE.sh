#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately
set -o pipefail  # Prevents errors in a pipeline from being masked

# VIEW_ONLY_MODE can be passed as environment variable, e.g. VIEW_ONLY_MODE=true ./FASTRESTORE.sh
VIEW_ONLY_MODE="${VIEW_ONLY_MODE:-false}"

echo "Make sure BorgBackup is installed and the repositories are accessible."
echo "The script will automatically list available backups and you can select one."
echo ""
echo "Set VIEW_ONLY_MODE to true if you want to only view the backup without restoring it."
echo "This can be useful to check the contents of a backup before restoring it."
echo ""

select_backup() {
  local repo=$1
  local mount_point=$2

  echo "Loading available backups from $repo..."
  archives=$(borg list "$repo" | awk '{print $1}')
  if [ -z "$archives" ]; then
    echo "No backups found in $repo."
    exit 1
  fi

  echo "Available backups:"
  i=1
  for archive in $archives; do
    echo "$i) $archive"
    i=$((i+1))
  done

  read -rp "Select the backup number: " num
  selected=$(echo $archives | cut -d' ' -f$num)
  if [ -z "$selected" ]; then
    echo "Invalid selection."
    exit 1
  fi

  echo "Mounting backup: $selected"
  borg mount -v -f "$repo::$selected" "$mount_point" &
  sleep 5  # Give it a moment to mount
}

restore-db() {
  local repo=~/server/backup/fivem-db
  local mount_point=~/server/backup/fivem-db-mount
  local app_dir=~/server/docker/phpmyadmin
  select_backup "$repo" "$mount_point"
  if [ "$VIEW_ONLY_MODE" = "true" ]; then
    echo "View-only mode is enabled. Skipping restore."
    read -rp "Press Enter to unmount and exit..."
    fusermount -u "$mount_point"  # Unmount the backup
    exit 0
  fi
  echo "Restoring fivem-db"
  (cd $app_dir && docker compose down)
  rsync --archive --verbose --delete --acls --progress "$mount_point/root/server/docker/phpmyadmin/db/" $app_dir/db/
  (cd $app_dir && docker compose up -d)
  fusermount -u "$mount_point"  # run if -f was not used during mount
}

restore-fivem() {
  local repo=~/server/backup/fivem
  local mount_point=~/server/backup/fivem-mount
  local app_dir=~/server/fivem
  select_backup "$repo" "$mount_point"
  if [ "$VIEW_ONLY_MODE" = "true" ]; then
    echo "View-only mode is enabled. Skipping restore."
    read -rp "Press Enter to unmount and exit..."
    fusermount -u "$mount_point"  # Unmount the backup
    exit 0
  fi
  echo "Restoring fivem"
  if [ -f $app_dir/docker-compose.yml ]; then
    (cd $app_dir && docker compose down)
  else
    systemctl stop fivemserver
  fi
  rsync --archive --verbose --delete --acls --progress "$mount_point/txData/" /txData/
  chmod -R 777 /txData/
  if [ -f $app_dir/docker-compose.yml ]; then
    (cd $app_dir && docker compose up -d)
  else
    systemctl start fivemserver
  fi
  fusermount -u "$mount_point"  # run if -f was not used during mount
}

restore-redm() {
  local repo=~/server/backup/redm
  local mount_point=~/server/backup/redm-mount
  local app_dir=~/server/redm
  select_backup "$repo" "$mount_point"
  if [ "$VIEW_ONLY_MODE" = "true" ]; then
    echo "View-only mode is enabled. Skipping restore."
    read -rp "Press Enter to unmount and exit..."
    fusermount -u "$mount_point"  # Unmount the backup
    exit 0
  fi
  echo "Restoring redm"
  if [ -f $app_dir/docker-compose.yml ]; then
    (cd $app_dir && docker compose down)
  else
    systemctl stop redmserver
  fi
  rsync --archive --verbose --delete --acls --progress "$mount_point/txData_rdr2/" /txData_rdr2/
  chmod -R 777 /txData_rdr2/
  if [ -f $app_dir/docker-compose.yml ]; then
    (cd $app_dir && docker compose up -d)
  else
    systemctl start redmserver
  fi
  fusermount -u "$mount_point"  # run if -f was not used during mount
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
    [ -d ~/server/docker/phpmyadmin ] && restore-db
    ;;
  2)
    [ -d ~/server/fivem ] && restore-fivem
    ;;
  3)
    [ -d ~/server/redm ] && restore-redm
    ;;
  4)
    [ -d ~/server/docker/phpmyadmin ] && restore-db
    [ -d ~/server/fivem ] && restore-fivem
    [ -d ~/server/redm ] && restore-redm
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

