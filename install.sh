# Install required packages
apt-get install -y apache2 php php-curl php-gd php-intl php-ldap php-mbstring php-xml php-zip libapache2-mod-php mysql-server php-mysql

# Download and extract GLPI
cd /var/www/html
wget https://github.com/glpi-project/glpi/releases/download/10.0.6/glpi-10.0.6.tgz
tar -xzf glpi-10.0.6.tgz
mv glpi /var/www/html/
chown -R www-data:www-data /var/www/html/glpi
chmod -R 755 /var/www/html/glpi

# Create GLPI database and user in MySQL
mysql -u root -e "CREATE DATABASE glpidb;"
mysql -u root -e "CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';"
mysql -u root -e "GRANT ALL PRIVILEGES ON glpidb.* TO 'glpi'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Configure Apache
echo "<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/glpi
    <Directory /var/www/html/glpi>
        Options FollowSymLinks
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/glpi.conf

a2ensite glpi
a2enmod rewrite
systemctl restart apache2

# Open firewall port for HTTP
ufw allow 80/tcp
