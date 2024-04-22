#!/bin/bash

cmdline=$(ps ax | grep '[L]eagueClientUx --riotclient-auth-token' | grep -v grep)

port=$(echo "$cmdline" | sed -n 's/.*--app-port=\([0-9]*\).*/\1/p')
token=$(echo "$cmdline" | sed -n 's/.*--remoting-auth-token=\([^ ]*\).*/\1/p')
auth=$(echo -n "riot:$token" | base64)

# you might need to close your client without touching anything after this.
curl --insecure --request POST -H "Authorization: Basic $auth" -H "Content-type: application/json" -d '{"challengeIds":[]}' "https://127.0.0.1:$port/lol-challenges/v1/update-player-preferences"
