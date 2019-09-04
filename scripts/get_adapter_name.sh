#!/bin/sh

route | grep '^default' | grep -o '[^ ]*$'
