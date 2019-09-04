#!/bin/sh

route | awk '{print $8}' | awk 'NR>2' | sort | uniq | wc -l
