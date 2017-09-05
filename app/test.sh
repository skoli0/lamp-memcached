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

check_service_status
