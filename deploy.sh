#!/bin/sh

#docker swarm init

./build.sh

echo "Closing no-ip_dns service if it running"
docker service inspect no-ip_dns > /dev/null
if [ $? -eq 0 ]; then
    docker service rm no-ip_dns
fi

echo "Setting secrets"
docker secret inspect username > /dev/null
if [ $? -eq 0 ]; then
    docker secret rm username
fi
printf "Enter username:"
read input
printf "$input" | docker secret create username -

docker secret inspect password > /dev/null
if [ $? -eq 0 ]; then
    docker secret rm password
fi
printf "Enter password:"
read input
printf "aan0usakis" | docker secret create password -


docker secret inspect domains > /dev/null
if [ $? -eq 0 ]; then
    docker secret rm domains
fi
printf "Enter domains (ex domain1.com or domain1.com domain2.com ... domainN.net):"
read input
printf "$input" | docker secret create domains -


docker secret inspect interval > /dev/null
if [ $? -eq 0 ]; then
    docker secret rm interval
fi
printf "Enter inerval:"
read input
printf "$input" | docker secret create interval -


docker stack deploy -c docker-compose.yml no-ip
