#!/bin/sh

set -e

# Both space and comma separated values are allowed
for i in ${WAIT_FOR//,/ }
do
    # Check port was correctly specified
    test "${i#*:}" != "$i" || { echo "[ERROR] Missing port for service '$i'. Exiting now!" ; exit 1; }
    
    # Wait for service to be ready
    /usr/local/bin/waitforit -host ${i%:*} -port ${i#*:} -retry $MILLIS_BETWEEN_WAIT_RETRIES -timeout $SECONDS_TO_WAIT -debug
done

/docker-entrypoint.sh kong start

tail -f /usr/local/kong/logs/*