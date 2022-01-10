#!/bin/sh

# based on https://docs.docker.com/config/containers/multi-service_container/

printf "Check and import env variables\n"

printf "Checking filename env variables\n"
if [ -z "$USERNAME_FILE" ] && [ -z "$PASSWORD_FILE" ] && [ -z "$DOMAINS_FILE" ] && [ -z "$INTERVAL_FILE" ]; then
  printf "Secret filenames doesn't exist\n"

  printf "Checking if env variables exist\n"
  if [ -z "$USERNAME" ] && [ -z "$PASSWORD" ] && [ -z "$DOMAINS" ] && [ -z "$INTERVAL" ]; then
    printf "env variables doen't exist\n"
    exit 1
  else
    printf "env variables exist\n"
    
  fi
else
  printf "Secret filenames exist\n"

  export USERNAME="$(cat $USERNAME_FILE)"
  export PASSWORD="$(cat $PASSWORD_FILE)"
  export DOMAINS="$(cat $DOMAINS_FILE)"
  export INTERVAL="$(cat $INTERVAL_FILE)"
fi

# Start the first process
# generate config file
echo "Starting process to generate config file"

./script.exp "$USERNAME" "$PASSWORD" "$DOMAINS" "$INTERVAL"
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start noip2 -C : $status"
  exit $status
fi
echo "Configuration file genereted successfully"


# Start the second process
# start no-ip dns update client
echo "Starting no-ip client"

noip2 -c /config/no-ip2.conf
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start noip2: $status"
  exit $status
fi
echo "No-ip client started successfully"

# Start the third process
echo "Starting Healthcheck monitoring"

./healthcheck.sh
status=$?
if [ $status -ne 0 ]; then
  echo "Healthcheck monitoring exited.: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if the second processes exited.
# The container exits with an erro if it detects that the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 10; do

  ps aux |grep noip2 |grep -q -v grep
  PROCESS_2_STATUS=$?

  ps aux |grep healthcheck.sh |grep -q -v grep
  PROCESS_3_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_2_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0 ]; then
    echo "Error."
    exit 1
  fi
done

