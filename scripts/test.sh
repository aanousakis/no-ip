#!/bin/sh

export USERNAME="aanousakis"
export PASSWORD="aan0usakis"
export DOMAINS="werttyy.ddns.net xcvdcvdfv.ddns.net gnghnfnfgf.ddns.net"
export INTERVAL="33"


echo $USERNAME
echo $PASSWORD
echo $DOMAINS
echo $INTERVAL

echo "Starting process to generate config file"

./script.exp "$USERNAME" "$PASSWORD" "$DOMAINS" "$INTERVAL"
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start noip2 -C : $status"
  exit $status
fi
echo "First procces exited successfully"
