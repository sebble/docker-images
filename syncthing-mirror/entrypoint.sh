#!/bin/sh
set -e
set -x

# check for env vars
test -n "$REMOTE_DEVICE_ID" && {
    test -f "/root/.config/syncthing/config.xml" || {
        syncthing --no-browser --no-restart &
        SYNCTHING_PID=$!
        sleep 10
        echo Sleeping for 10 seconds...
        kill $SYNCTHING_PID
    }
    #API_KEY=$(xmlstarlet sel -t -v /configuration/gui/apikey /root/.config/syncthing/config.xml)
    grep -Fq "$REMOTE_DEVICE_ID" /root/.config/syncthing/config.xml || {
        # enforce one-way sync
        xmlstarlet edit -P -L --update '/configuration/folder[@path="/root/Sync/"]/@type' --value readonly /root/.config/syncthing/config.xml
        # add remote device to folder
        xmlstarlet edit -P -L --subnode '/configuration/folder[@path="/root/Sync/"]' -t elem -n NEWDEVICE \
            -i //NEWDEVICE -t attr -n id -v $REMOTE_DEVICE_ID \
            -i //NEWDEVICE -t attr -n introducedBy -v "" \
            -r //NEWDEVICE -v device \
            /root/.config/syncthing/config.xml
        # add remote device to root
        xmlstarlet edit -P -L --subnode '/configuration' -t elem -n NEWDEVICE \
            -i //NEWDEVICE -t attr -n id -v $REMOTE_DEVICE_ID \
            -i //NEWDEVICE -t attr -n name -v "" \
            -i //NEWDEVICE -t attr -n compression -v metadata \
            -i //NEWDEVICE -t attr -n introducer -v false \
            -i //NEWDEVICE -t attr -n skipIntroductionRemovals -v false \
            -i //NEWDEVICE -t attr -n introducedBy -v "" \
            -s //NEWDEVICE -t elem -n address -v dynamic \
            -s //NEWDEVICE -t elem -n paused -v false \
            -r //NEWDEVICE -v device \
            /root/.config/syncthing/config.xml
    }
}
# check for config file
# run syncthing temporarily

exec "$@"
