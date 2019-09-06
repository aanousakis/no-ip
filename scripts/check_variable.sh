#!/bin/sh

export USERNAME=antony
export PASSWOD=123456
export DOMAINS="[facebook.com google.com]"
export INTERVAL=789




if [ -a "$USERNAME_FILE" ] && [ -a "$PASSWORD_FILE" ] && [ -a "$DOMAINS_FILE" ] && [ -a "$INTERVAL_FILE" ]; then
  printf "Secrets exist" 
fi

