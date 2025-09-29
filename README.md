# FXserver Install Scripts

The scripts folder contains the installation scripts for FiveM, RedM, and phpMyAdmin.

## Notes
- This branch contains adjustments to the FiveM txAdmin installation script and an adjusted `backup-fivem.sh` script (if `install-backup-solution.sh` is run) because the installation method has been changed to be multi-user friendly. If you have several helpers on a server who want to upload things to the `txData` via `scp`, it is also possible with separate user profiles.
- The directory of txData can be found under `/` instead of in the `/root` folder.

A collection of scripts to install the FXserver and additional extensions.

> [!NOTE]
> - An AIO install script to install FiveM (native) and MariaDB, phpMyAdmin (with and without Docker container) is available.
> - When the AIO script is executed, a log file is created in the home directory of the user being executed (e.g., `root` under `/root` or `~`). This also contains the automatically assigned password for the root user of the database, otherwise it is output if the phpMyAdmin install script was executed manually.
> - Use the appropriate AIO script:
>   - [LXC](./0-aio_installscript-lxc.sh) for LXC on Proxmox or vServer.
>   - [VM](./0-aio_installscript-vm.sh) for self-hosted VM or root server.

> [!IMPORTANT]
> - The scripts are optimized for Debian and Ubuntu systems (x64 architecture only).
> - So far only tested on the following systems:
>   - `Ubuntu 22.04`
>   - `Ubuntu 24.04`

### Test state:
[![Test AIO Installscript](https://github.com/LizenzFass78851/fxserverinstallscripts/actions/workflows/test-aio-installscript.yml/badge.svg?branch=main)](https://github.com/LizenzFass78851/fxserverinstallscripts/actions/workflows/test-aio-installscript.yml)
