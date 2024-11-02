#!/bin/bash

set -e

# Set environment variable to avoid interactive prompts
DEBIAN_FRONTEND=noninteractive

# Update package list
DEBIAN_FRONTEND=$DEBIAN_FRONTEND apt update

# Install Apache2, PHP, MariaDB, and phpMyAdmin
DEBIAN_FRONTEND=$DEBIAN_FRONTEND apt install -y apache2 php libapache2-mod-php mariadb-server php-mysql phpmyadmin

# Start and enable Apache2 and MariaDB services
systemctl start apache2
systemctl enable apache2
systemctl start mariadb
systemctl enable mariadb

# Function to generate a random password
function pw() {
    < /dev/urandom tr -dc A-Za-z0-9 | head -c $1; echo
}

# Generate a random password for MariaDB root user
DB_ROOT_PASS=$(pw 16)

# Secure MariaDB installation
mysql_secure_installation <<EOF

y
y
$DB_ROOT_PASS
$DB_ROOT_PASS
y
y
y
y
EOF

# Configure phpMyAdmin
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# Restart Apache2 to apply changes
systemctl restart apache2

# Display the generated MariaDB root password
echo /////////////////////////////////////////////////////////////
echo PHPMYADMIN and SQL Root Password:
echo $DB_ROOT_PASS
echo /////////////////////////////////////////////////////////////

echo Please make sure you write down the password!
echo Only with the password can you access the phpmyadmin UI.

echo "phpMyAdmin is available at http://localhost/phpmyadmin"
