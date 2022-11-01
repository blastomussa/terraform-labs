#!/bin/bash
sudo apt update
sudo apt install -y apache2 \
                 ghostscript \
                 libapache2-mod-php \
                 mysql-server \
                 php \
                 php-bcmath \
                 php-curl \
                 php-imagick \
                 php-intl \
                 php-json \
                 php-mbstring \
                 php-mysql \
                 php-xml \
                 php-zip \
                 vim

# Create the installation directory and download the file from WordPress.org
sudo mkdir -p /srv/www
sudo chown www-data: /srv/www
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www

# Configure Apache for WordPress
cat << EOF > /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Enable the site
sudo a2ensite wordpress

# Enable URL rewriting
sudo a2enmod rewrite

# Disable the default “It Works” site
sudo a2dissite 000-default

# reload apache
sudo service apache2 reload

sudo mysql -u root --execute="CREATE DATABASE wordpress; CREATE USER wordpress@localhost IDENTIFIED BY ${password}; GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost; FLUSH PRIVILEGES;"

# enable mysql
sudo service mysql start

#copy the sample configuration file to wp-config.php
sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php

# still requires additional configuration via ssh: https://ubuntu.com/tutorials/install-and-configure-wordpress#6-configure-wordpress-to-connect-to-the-database