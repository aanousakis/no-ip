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

  USERNAME="$(cat $USERNAME_FILE)"
  PASSWORD="$(cat $PASSWORD_FILE)"
  DOMAINS="$(cat $DOMAINS_FILE)"
  INTERVAL="$(cat $INTERVAL_FILE)"
fi

printf "USERNAME [$USERNAME]\n"
printf "PASSWORD [$PASSWORD]\n"
printf "DOMAINS  [$DOMAINS]\n"
printf "INTERVAL [$INTERVAL]\n"


# Start the first process
# generate config file
echo "Starting process to generate config file"

env

./script.exp "$USERNAME" "$PASSWORD" "$DOMAINS" "$INTERVAL"
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

