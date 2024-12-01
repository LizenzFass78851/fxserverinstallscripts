# FXserver Install Scripts

- the scripts folder contains the installation scripts for fivem, redm, phpmyadmin 
------
- this branch contains adjustments to the fivem txadmin installation script and an adjusted `backup-fivem.sh` script (if `install-backup-solution.sh`) is run because the installation method has been changed to be multi-user friendly. So if you have several helpers on a server who want to upload things to the `txData` via `scp`, it is also possible with separate user profiles.
- the directory of txdata can be found under `/` instead of in `/root` folder
a collection of scripts to install the fxserver + additional extensions over the install scripts

> [!NOTE]
> - a aio installscript to install fivem (native) and mariadb, phpmyadmin (with and without as docker container) is available
>
>   - When the AIO script is executed, a log file is created in the home directory of the user being executed (e.g. `root` under `/root` or `~`). This also contains the automatically assigned password for the root user of the database, otherwise it is output if the phpmyadmin install script was executed manually.
>
>   - User the appropriate aio script:
>     [lxc](./0-aio_installscript-lxc.sh) for lxc on proxmox or vserver, [vm](./0-aio_installscript-vm.sh) for self hosted vm or root server.

> [!IMPORTANT]
> - the scripts are optimized for debian and ubuntu systems (x64 architecture only)
>
> - So far only tested on the following systems:
>   - `ubuntu 22.04`; `ubuntu 24.04`
