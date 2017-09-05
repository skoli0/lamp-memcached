#!/bin/bash
set -x
# ------------------------------------------------------------------------------
# [Author] skoli0
#          Sets appropriate environmental variables, installs memcached and sets
#          test data for memcached stats to display on page
# ------------------------------------------------------------------------------

# Installs memcached
function configure_memcached() {
	export DEBIAN_FRONTEND=noninteractive
    # Install memcachedd, a high-performance memory object caching system service
    echo "--- Install memcached, a high-performance memory object caching system..."
	apt-get install memcached -y
}

# Installs memcached and sets test data for memcached stats to display on page
function set_memcached_data() {
    set +x
    # Set memcache data for testing, to show on stats page
    for number in {1..5000}
    do
            echo -e "set testkey$number 0 60 10\r\nhelloworld\r" | nc localhost 11211 > /dev/null 2>&1
    done

    # Get memcache data for testing, to show on stats page, hits
    for number in {1..3000}
    do
            echo -e "get testkey$number\r" | nc localhost 11211 > /dev/null 2>&1
    done

    # Get memcache data for testing, to show on stats page, misses
    for number in {1..2000}
    do
            echo -e "get failedtestkey$number\r" | nc localhost 11211 > /dev/null 2>&1
    done
}

# Call all the function defined avbove
configure_memcached
set_memcached_data
