#!/bin/bash

trap "clean_up" SIGTERM
function clean_up() {
    for i in {5..1}
    do
        echo $i
        ( echo "say \"Server stopping in ${i}\"\rexit\r" ) | telnet 127.0.0.1 8081
        sleep 1
    done

    ( echo "shutdown\r" ) | telnet 127.0.0.1 8081
    kill -SIGINT $serverPID
}

cd ${STEAMAPPDIR}

if [ $AUTO_UPDATE]; then
    steamcmd \
	+force_install_dir "${STEAMAPPDIR}" \
	+login ${STEAM_LOGIN} \
	+app_update "${STEAMAPP_ID}" validate \
	+quit
fi

# We assume that if the config is missing, that this is a fresh container
if [ ! -f "${STEAM_SAVEDIR}/serverconfig.xml" ]; then
    cp "${STEAMAPPDIR}/serverconfig.xml" ${STEAM_SAVEDIR}
    # Add in config file modification using environment variables
    # Example:
    # xmlstarlet ed --inplace -u '/ServerSettings/property[@name="ServerName"]/@value' -x 'string("I have changed")' serverconfig.xml
fi

export LD_LIBRARY_PATH=.

${STEAMAPPDIR}/7DaysToDieServer.x86_64 -quit -batchmode -nographics -dedicated -configfile=${STEAM_SAVEDIR}/serverconfig.xml & serverPID=$!
wait $serverPID
exit 0
