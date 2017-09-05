#!/bin/bash
# ------------------------------------------------------------------------------
# [Author] skoli0
#          Add a cronjob that runs /home/vagrant/exercise-memcached.sh
#          once per minute
# ------------------------------------------------------------------------------

MEMCACHED_EXERCISE=$HOME/exercise-memcached.sh
MEMCACHED_EXERCISE_CRONLOG=$HOME/exercise-memcached.log

# Create new memcached exercise cron job in one line
crontab -l | grep "$MEMCACHED_EXERCISE" || (crontab -l 2>/dev/null; echo "* * * * * $MEMCACHED_EXERCISE") | crontab -

# Remove previous files to avoid redundancy
rm -rfv ${MEMCACHED_EXERCISE}
rm -rfv ${MEMCACHED_EXERCISE_CRONLOG}

if [ ! -f "${MEMCACHED_EXERCISE}" ]; then
cat << EOF > ${MEMCACHED_EXERCISE}
#!/bin/bash
dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt Hello, World!, A cron job that runs once per minute." >> ${MEMCACHED_EXERCISE_CRONLOG}
EOF
chmod +x ${MEMCACHED_EXERCISE}
fi
