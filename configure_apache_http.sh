#!/bin/bash
set -x
# -------------------------------------------------------------------------------------------
# [Author] skoli0
#          Sets appropriate environmental variables, installs Apache2,
#          configures it to run using HTTP
# -------------------------------------------------------------------------------------------

# Default user of the system
user="vagrant"

# Apache configuration details
apache_config_file="/etc/apache2/envvars"
apache_vhost_file="/etc/apache2/sites-available/app.conf"
apache_ssl_dir="/etc/apache2/ssl/certs"
project_doc_root="/var/www"
project_web_root="app"
default_apache_index="${project_doc_root}/${project_web_root}/index.html"

welcome_page="
<!DOCTYPE html>
<html>
<head>
<title>Test Page</title>
</head>
<body>

<h1>Hello, World!</h1>
<p>This is welcome page from Custom App.</p>

</body>
</html>
"
# Organization details required for SSL Certificate
country="IN"
state="Maharashtra"
locality="Pune"
organization="localhost"
commonname="vagrant"
organizationalunit="CloudIT"
email="webmaster@localhost"

# Main function to call all the sub-functions, called at the very bottom of the script
function main() {
    configure_system
    #configure_network
    configure_apache_http
    cleanup_system
}


function configure_system() {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install curl
    apt-get upgrade -y
}

function configure_network() {
    echo "test"
}

function configure_apache_https() {

    mkdir -p ${apache_ssl_dir}
    type sublime >/dev/null 2>&1 || { echo >&2 "OpenSSL is not installed. Installing it..."; \
    apt-get install openssl -y;}
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ${apache_ssl_dir}/apache.key -out ${apache_ssl_dir}/apache.crt \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
}

function configure_apache_http() {
    apt-get install apache2 -y
    # Setup instance of Apache on port 8080
    #####Testing purpose only
    sed -i '/Listen 8080/d' /etc/apache2/ports.conf
    sed -i '/Listen 80/a Listen 8080' /etc/apache2/ports.conf

    # Setup ServerName in servername.conf
    echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/servername.conf
    # Enable the apache configuration file
    a2enconf servername

    # Restart Apache to make these changes take effect
    #/etc/init.d/apache2 restart

    # Check Apache is up and running
    #check_service_status

    # Create Virtual Directory for app
    mkdir -p ${project_doc_root}/${project_web_root}

    # Create Test Web Pages for Virtual Host
    echo ${welcome_page} > ${default_apache_index}

    # Setting Up Ownership and Permissions
    chown -R www-data:www-data ${project_doc_root}/${project_web_root}
    chmod -R 755 ${project_doc_root}/${project_web_root}
    chown -R ${user} ${project_doc_root}/${project_web_root}

    # Disable default virtual host file
    a2dissite 000-default.conf

    # Create new virtual host file
    rm -rfv ${apache_vhost_file}

    if [ ! -f "${apache_vhost_file}" ]; then
        cat << EOF > ${apache_vhost_file}
<VirtualHost *:8080>

ServerAdmin admin@localhost
ServerName  localhost
DocumentRoot ${project_doc_root}
#DirectoryIndex index.html

ErrorLog /var/log/apache2/app_error.log
CustomLog /var/log/apache2/app_access.log combined

<Directory ${project_doc_root}>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>

</VirtualHost>
EOF
    fi

    # Enable the new virtual host
    a2ensite app.conf

    # Finally, restart the Apache service.
    /etc/init.d/apache2 restart

    # Check Apache is up and running
    check_service_status

    # Provision scripts gets executed as root user by default, launch web browser as vagrant user
    runuser -l vagrant -c "export DISPLAY=:0.0; xdg-open http://localhost:8080/app > /dev/null 2>&1 &"
}

check_service_status() {
    #checking if Apache is running or not
    if /etc/init.d/apache2 status > /dev/null;
    then
        echo "Apache is already running";
    else
        echo "Apache is not running, starting it...";
        service apache2 start
        sleep 2
        check_service_status
    fi
}

cleanup_system() {
    apt-get autoremove -y
}

main
