#!/bin/bash

pid=$(pidof "LeagueClientUx.exe")
# these are null separated but cat -v replaces null characters with ^@
cmdline=$(cat -v /proc/$pid/cmdline)
port=$(echo $cmdline | sed -n -e 's/.*--app-port=\([0-9]*\)^@.*/\1/p')
token=$(echo $cmdline | sed -n -e 's/.*--remoting-auth-token=\([a-zA-Z0-9]*\)^@.*/\1/p')
auth=$(echo -n "riot:$token" | base64)

# you might need to close your client without touching anything after this.
curl --insecure --request POST -H "Authorization: Basic $auth" -H "Content-type: application/json" -d "{\"challengeIds\":[]}" https://127.0.0.1:$port/lol-challenges/v1/update-player-preferences
