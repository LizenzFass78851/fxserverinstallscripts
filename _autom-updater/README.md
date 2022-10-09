# automatic updater 
## for fivem and docker images

- these scripts can be started with systemctl and thus automatically update fivem and selected docker images.

- enter the correct root directory of the fivem (fxserver) in the scripts so that it works, the same for the docker updater script where the subfolders for the docker-compose files are located

- the docker updater script contains examples for updating selected images. therefore possibly ensure that the docker image updater script contains only the phases that update the images that also exist in the server

- ein beispiel einer systemctl service vorlage gibt es [hier](../backup-solution)