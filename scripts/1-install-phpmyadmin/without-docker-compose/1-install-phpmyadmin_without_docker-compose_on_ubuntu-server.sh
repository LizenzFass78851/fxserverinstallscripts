#!/bin/bash

set -e

# Function to generate a random password
function pw() {
    < /dev/urandom tr -dc A-Za-z0-9 | head -c $1; echo
}

# Create the setting-mariadb.exp file
cat << 'EOF' > setting-mariadb.exp
#!/bin/expect -f
set timeout 1
if {[llength $argv] == 0} {
    send_user "Usage: mariadb_sec.exp \[mysql root password\]\n"
    exit 1
}
set PASSWORD [lindex $argv 0];

spawn mysql_secure_installation
set mysql_spawn_id $spawn_id

# optionally, redirect output to log file (silent install)
# log_user 0
# log_file -a "/home/[exec whoami]/mariadb_install.log"

# when there is no password set, this probably should be "\r"
expect -ex "Enter current password for root (enter for none): "
exp_send "$PASSWORD\r"

expect -ex "Switch to unix_socket authentication \[Y/n\] "
exp_send "Y\r"

expect {
    # await an eventual error message
    -ex "ERROR 1045" {
        send_user "\nMariaDB > An invalid root password had been provided.\n"
        close $mysql_spawn_id
        exit 1
    }
    # when there is a root password set
    -ex "Change the root password? \[Y/n\] " {
        exp_send "Y\r"
        expect -ex "New password: "
        exp_send "$PASSWORD\r"
        expect -ex "Re-enter new password: "
        exp_send "$PASSWORD\r"
    }
    # when there is no root password set (could not test this branch).
    -ex "Set root password? \[Y/n\] " {
        exp_send "Y\r"
        expect -ex "New password: "
        exp_send "$PASSWORD\r"
        expect -ex "Re-enter new password: "
        exp_send "$PASSWORD\r"
    }
}
expect -ex "Remove anonymous users? \[Y/n\] "
exp_send "Y\r"
expect -ex "Disallow root login remotely? \[Y/n\] "
exp_send "Y\r"
expect -ex "Remove test database and access to it? \[Y/n\] "
exp_send "Y\r"
expect -ex "Reload privilege tables now? \[Y/n\] "
exp_send "Y\r"

expect eof
close $mysql_spawn_id
exit 0
EOF

# Make the setting-mariadb.exp file executable
chmod +x setting-mariadb.exp

# Set environment variable to avoid interactive prompts
DEBIAN_FRONTEND=noninteractive

# Update package list
DEBIAN_FRONTEND=$DEBIAN_FRONTEND apt update

# Install Apache2, PHP, MariaDB, and phpMyAdmin
DEBIAN_FRONTEND=$DEBIAN_FRONTEND apt install -y apache2 php libapache2-mod-php mariadb-server php-mysql phpmyadmin \
expect

# Start and enable Apache2 and MariaDB services
systemctl start apache2
systemctl enable apache2
systemctl start mariadb
systemctl enable mariadb

# Generate a random password for MariaDB root user
DB_ROOT_PASS=$(pw 16)

# Secure MariaDB installation
./setting-mariadb.exp $DB_ROOT_PASS

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
