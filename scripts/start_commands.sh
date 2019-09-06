#!/bin/sh

# based on https://docs.docker.com/config/containers/multi-service_container/


./check_variable.sh

echo "reading secrets"

printf "secret USERNAME ["
cat /run/secrets/username
printf "]\n"

printf "secret PASSWORD ["
cat /run/secrets/password
printf "]\n"

printf "secret DOMAINS ["
cat /run/secrets/domains
printf "]\n"

printf "secret INTERVAL ["
cat /run/secrets/interval
printf "]\n"



# Start the first process
# generate config file
echo "Starting process to generate config file"

./script.exp
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start noip2 -C : $status"
  exit $status
fi
echo "First procces exited successfully"


# Start the second process
# start the client
echo "Starting no-ip client"

noip2
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start noip2: $status"
  exit $status
fi
echo "No-ip client started successfully"

# Naive check runs checks once a minute to see if the second processes exited.
# The container exits with an erro if it detects that the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps aux |grep noip2 |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_2_STATUS -ne 0 ]; then
    echo "noip2 processes has exited."
    exit 1
  fi
done

