#!/bin/bash
set -x
# -------------------------------------------------------------------------------------------------------------------------------
# [Author] skoli0
#          Sets reconfigures Apache2, creates self-signed certificates to run using HTTPS
# -------------------------------------------------------------------------------------------------------------------------------

apache_vhost_file="/etc/apache2/sites-available/app.conf"
apache_selfsigned_cert_dir="/etc/apache2/ssl/certs"
project_doc_root="/var/www"
project_web_root="app"

# Organization details required for SSL Certificate
domain=localhost
commonname=$domain
 
#Change as per your company details
country=IN
state=Maharashtra
locality=Pune
organization=localhost
organizationalunit=DevOps
email=webmaster@localhost
 
#Optional
password=vagrant
 
create_selfsigned_cert() { 
    # Create the CSR and Key
    echo "Creating self-signed key and certificate pair with OpenSSL in a single command"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout apache-selfsigned.key -out apache-selfsigned.crt -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
     
    echo "---------------------------"
    cat apache-selfsigned.crt
     
    echo
    echo "---------------------------"
    cat apache-selfsigned.key
    
    # Create a strong Diffie-Hellman group
    openssl dhparam -out apache-selfsigned.pem 2048 > /dev/null 2>&1

    # Place them in SSL Certificate directory
    mkdir -p ${apache_selfsigned_cert_dir}
    mv apache-selfsigned.* ${apache_selfsigned_cert_dir}/.
}

function configure_apache_https() {
    # Create Self-signed SSL certificates
    create_selfsigned_cert
    # Setup instance of Apache on port 8080
    #####Testing purpose only
    sed -i '/Listen 8443/d' /etc/apache2/ports.conf
    #######################
    sed -i '/Listen 8080/a Listen 8443' /etc/apache2/ports.conf

    # Restart Apache to make these changes take effect
    #/etc/init.d/apache2 restart

    # Check Apache is up and running
    check_service_status
    cat << EOF >> ${apache_vhost_file}
<VirtualHost *:8443>

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

    SSLEngine on
    # Using Self-signed SSL certificates
    SSLCertificateFile  ${apache_selfsigned_cert_dir}/apache-selfsigned.crt
    SSLCertificateKeyFile ${apache_selfsigned_cert_dir}/apache-selfsigned.key
</VirtualHost>
EOF
    # Enable Apache SSL module 
    a2enmod ssl
    a2enmod headers

    # Enable the new virtual host
    a2ensite app.conf
    
    # Finally, restart the Apache service.
    /etc/init.d/apache2 restart
    
    # Check Apache is up and running
    check_service_status
    
    # Testing app virtual host by opening a URL in the user's preferred application
    #sh -c "xdg-open https://localhost:8443/app &"

    # Testing app virtual host by using curl (non-gui) and just ignore SSL certificate
    # Curl to app link in case server is installed without GUI...
    curl -L -k -s https://localhost:8443/app
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

configure_apache_https
