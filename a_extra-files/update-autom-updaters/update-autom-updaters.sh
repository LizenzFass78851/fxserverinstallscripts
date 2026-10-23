#!/bin/bash

set -u

readonly DOWNLOAD_BASE_URL="https://github.com/LizenzFass78851/fxserverinstallscripts/raw/main/_files/autom-updater"

update_updater() {
    local server_directory="$1"
    local updater_file="$2"
    local updater_name="$3"
    local updater_directory="$HOME/server/${server_directory}/_autom-updater"
    local target_file="${updater_directory}/${updater_file}"
    local temporary_file

    # This script updates existing installations only. It never creates them.
    if [ ! -f "${target_file}" ]; then
        echo "${updater_name} updater not found. Skipping update."
        return 0
    fi

    temporary_file=$(mktemp)
    if ! wget -q --timeout=30 --tries=1 -O "${temporary_file}" \
        "${DOWNLOAD_BASE_URL}/${updater_file}"; then
        echo "Could not download the current ${updater_name} updater. Skipping update." >&2
        rm -f "${temporary_file}"
        return 1
    fi

    if cmp -s "${temporary_file}" "${target_file}"; then
        echo "${updater_name} updater is already up to date."
        rm -f "${temporary_file}"
        return 0
    fi

    # Keep the existing file permissions and replace the script only when changed.
    local file_mode
    file_mode=$(stat -c '%a' "${target_file}")
    install -m "${file_mode}" "${temporary_file}" "${target_file}"
    rm -f "${temporary_file}"

    echo "${updater_name} updater was updated."
    return 0
}

update_updater "fivem" "fivem-updater.sh" "FiveM"
update_updater "fivemenhanced" "fivemenhanced-updater.sh" "FiveM Enhanced"
update_updater "redm" "redm-updater.sh" "RedM"

echo "Updater update check completed."
