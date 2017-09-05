#!/bin/bash
set -x
# ------------------------------------------------------------------------------
# [Author] skoli0
#          Installs PHP, PHP-Memcache PHP-Memcached modules and adds memcached
#          web app to monitor memcached stats
# ------------------------------------------------------------------------------

# Installs PHP, PHP-Memcache PHP-Memcached modules
function configure_php() {
    # Set DEBIAN_FRONTEND environmental variable to apt-get noninteractive install
    export DEBIAN_FRONTEND=noninteractive
    # DISPLAY environment variable which generally points to an X Display server
    # located on your local computer
    export DISPLAY=:0.0

    # Install PHP and server-side, HTML-embedded scripting language (Apache 2 module)
    echo "--- Install PHP and server-side, HTML-embedded scripting language (Apache 2 module)..."
	apt-get install php libapache2-mod-php -y
    # Install memcached extension modules for PHP5
    echo "--- Install memcached extension modules for PHP5..."
    apt-get install php-memcache php-memcached -y

    # Move the PHP index file to the first position so that Apache serve them properly
    echo "--- Move the PHP index file to the first position so that Apache serve them properly ..."
    sed -i '/DirectoryIndex /c\\tDirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm' \
    /etc/apache2/mods-enabled/dir.conf
}

# Adds memcached web app to monitor memcached stats
function configure_memcached_stats_app() {
    # Untar app.tar.gz in document root directory /var/www/
    echo "--- Untar app.tar.gz in document root directory /var/www/..."
    tar -xvf /tmp/app.tar.gz -C /var/www/

    # Restart the Apache server
    echo "--- Restart the Apache server..."
    service apache2 restart
    # Check the running status Apache server
    echo "--- Check the status of Apache server running or not..."
    service apache2 status
}

configure_php
configure_memcached_stats_app
