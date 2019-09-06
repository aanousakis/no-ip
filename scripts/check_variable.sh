#!/bin/sh

printf "set env\n"
#export USERNAME=antony
#export PASSWORD=123456
#export DOMAINS="[facebook.com google.com]"
#export INTERVAL=789



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
printf "DOMAINS $DOMAINS\n"
printf "INTERVAL [$INTERVAL]\n"




