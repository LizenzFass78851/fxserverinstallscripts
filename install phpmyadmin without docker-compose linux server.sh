#!/bin/bash
# Phymyadmin/Apache2 Installer

# Config

PhymyadminConfig="# phpMyAdmin Apache configuration

Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>" 
	
	
Secureeinstellung="Die erste Frage können Sie mit Enter einfach überspringe, dannach kommt eine Abfrage für in selbst hinterlegtes Root MySQL Passwort. Dies können Sie selber festelegen, die nächsten abfragen sind für die Grundeinstellungen des Servers.\033[0m"

# Willkommensteil
clear
echo -e "\033[32mHerzlich Willkommen, beim Phymyadmin/Apache2 Installer" 
echo -e "Entwickelt vom Domisiding WebProjekt" 
echo -e ""

# System abfrage / Sicherheitseinstellungen
echo -e "Welchen Betriebsystem besitzen Sie?\033[0m"
 OPTIONS=("Debian" "Ubuntu") 
select OPTION in "${OPTIONS[@]}"; do
  case "$REPLY" in
  1 | 2) break
  esac
done
  
  
 if [ "$OPTION" == "Debian" ]; then
  Option="Debian" 
  elif [ "$OPTION" == "Ubuntu" ]; then
  Option="Ubuntu" 

  
  fi

 if [[ $Option == "Debian" ]]; then
		apt install ca-certificates apt-transport-https lsb-release gnupg curl nano unzip -y
		wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
		echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
		apt update
		apt install apache2 -y
		apt install php7.4 php7.4-cli php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-xml php7.4-xsl php7.4-zip php7.4-bz2 libapache2-mod-php7.4 -y
		apt install mariadb-server mariadb-client -y
		cd /usr/share
		wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O phpmyadmin.zip
		unzip phpmyadmin.zip
		rm phpmyadmin.zip
		mv phpMyAdmin-*-all-languages phpmyadmin
		chmod -R 0755 phpmyadmin
		rm nano /etc/apache2/conf-available/phpmyadmin.conf
		echo "${PhymyadminConfig}" > /etc/apache2/conf-available/phpmyadmin.conf
		a2enconf phpmyadmin
		systemctl reload apache2
		mkdir /usr/share/phpmyadmin/tmp/
		chown -R www-data:www-data /usr/share/phpmyadmin/tmp/
		clear
		echo -e "\033[32mIn dem nächsten Abteil, müssen Sie die Daten alleine eintragen."
		echo -e ""
		echo -e "${Secureeinstellung}"
		sleep 10 && mysql_secure_installation 
		
		# Sicherheitseinstellungen
clear		
echo -e "\033[32mWelche Sicherheitseinstellungen möchten Sie?\033[0m" 
OPTIONS=("Root Login" "Neuer Benutzer")
select OPTION in "${OPTIONS[@]}"; do
  case "$REPLY" in
  1 | 2) break
  esac
done
  
  
if [ "$OPTION" == "Root Login" ]; then
  Option="Root" 
  elif [ "$OPTION" == "Neuer Benutzer" ]; then
  Option="Benutzer" 

  fi 
  
if [[ $Option == "Root" ]]; then
		clear
		echo -e "\033[32mMit dieser Sicherheitseinstellungen ist es möglich, dass Sie sich mit dem Root Benutzer einloggen können\033[0m"
		echo -e "\033[32mGib dein Hinterlegtes Passwort ein, für die MySQL"
    mysql -u root -p  -Bse "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root' AND plugin = 'unix_socket';FLUSH PRIVILEGES;" 
		echo -e "\033[32mDie Sicherheitseinstellungen sind nun hinterlegt.\033[0m"
fi 
	
if [[ $Option == "Benutzer" ]]; then
		clear
		echo -e "\033[32mMit dieser Sicherheitseinstellungen wird ein neuer Benutzer angelegt mit dem Sie sich einloggen können\033[0m"
		read -p "Wie soll der Benutzer heißen:" mysqluser
		echo -e "\033[32mGib dein Hinterlegtes Passwort ein, für die MySQL"
		mysql -u root -p -Bse "CREATE USER '${mysqluser}'@'localhost' IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON *.* TO '${mysqluser}'@'localhost' WITH GRANT OPTION;" 
		echo -e "\033[32mDie Sicherheitseinstellungen sind nun hinterlegt.\033[0m"
fi 


		fi 
		
if [[ $Option == "Ubuntu" ]]; then
		apt install ca-certificates apt-transport-https lsb-release gnupg curl nano unzip -y
		apt install software-properties-common -y
		add-apt-repository ppa:ondrej/php
		apt update
		apt install apache2 -y
		apt install php7.4 php7.4-cli php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-readline php7.4-xml php7.4-xsl php7.4-zip php7.4-bz2 libapache2-mod-php7.4 -y
		apt install mariadb-server mariadb-client -y
		cd /usr/share
		wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O phpmyadmin.zip
		unzip phpmyadmin.zip
		rm phpmyadmin.zip
		mv phpMyAdmin-*-all-languages phpmyadmin
		chmod -R 0755 phpmyadmin
		rm nano /etc/apache2/conf-available/phpmyadmin.conf
		echo "${PhymyadminConfig}" > /etc/apache2/conf-available/phpmyadmin.conf
		a2enconf phpmyadmin
		systemctl reload apache2
		mkdir /usr/share/phpmyadmin/tmp/
		chown -R www-data:www-data /usr/share/phpmyadmin/tmp/
		clear
		echo -e "\033[32mIn dem nächsten Abteil, müssen Sie die Daten alleine eintragen."
		echo -e ""
		echo -e "${Secureeinstellung}"
		sleep 10 && mysql_secure_installation 
		
		# Sicherheitseinstellungen
		clear
echo -e "\033[32mWelche Sicherheitseinstellungen möchten Sie?\033[0m" 
OPTIONS=("Root Login" "Neuer Benutzer")
select OPTION in "${OPTIONS[@]}"; do
  case "$REPLY" in
  1 | 2) break
  esac
done
  
  
if [ "$OPTION" == "Root Login" ]; then
  Option="Root" 
  elif [ "$OPTION" == "Neuer Benutzer" ]; then
  Option="Benutzer" 

  fi 
  
if [[ $Option == "Root" ]]; then
		clear
		echo -e "\033[32mMit dieser Sicherheitseinstellungen ist es möglich, dass Sie sich mit dem Root Benutzer einloggen können\033[0m"
		echo -e "\033[32mGib dein Hinterlegtes Passwort ein, für die MySQL"
    mysql -u root -p  -Bse "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root' AND plugin = 'unix_socket';FLUSH PRIVILEGES;" 
		echo -e "\033[32mDie Sicherheitseinstellungen sind nun hinterlegt.\033[0m"
		
fi 
	
if [[ $Option == "Benutzer" ]]; then
		clear
		echo -e "\033[32mMit dieser Sicherheitseinstellungen wird ein neuer Benutzer angelegt mit dem Sie sich einloggen können\033[0m"
		read -p "Wie soll der Benutzer heißen:" mysqluser
		echo -e "\033[32mGib dein Hinterlegtes Passwort ein, für die MySQL"
		mysql -u root -p -Bse "CREATE USER '${mysqluser}'@'localhost' IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON *.* TO '${mysqluser}'@'localhost' WITH GRANT OPTION;" 
		echo -e "\033[32mDie Sicherheitseinstellungen sind nun hinterlegt.\033[0m"
fi 
		
		fi 
		

