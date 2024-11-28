# FXserver Install Scripts

- the scripts folder contains the installation scripts for fivem, redm, phpmyadmin 
------
- this branch contains adjustments to the fivem txadmin installation script and an adjusted backup-fivem.sh script (if install-backup-solution.sh) is run because the installation method has been changed to be multi-user friendly. So if you have several helpers on a server who want to upload things to the txData via scp, it is also possible with separate user profiles.
- the directory of txdata can be found under "/" instead of in "/root" folder
a collection of scripts to install the fx server + additional extensions in the form of install scripts

> [!NOTE]
> - a aio installscript to install fivem (native) and mariadb, phpmyadmin (only as docker container) is available
>
>   -  Does not work on vserver (without kvm support) but at best on root server or self-hosted as vm and not as lxc.

> [!IMPORTANT]
> - the scripts are optimized for debian and ubuntu systems (x64 architecture only)
