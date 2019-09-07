#!/bin/sh

while sleep $(( $INTERVAL*0.1 )); do

  if [[ "$(ping -c 1 8.8.8.8 | grep '0% packet loss' )" != "" ]]; then
      #echo "Internet is present"

      my_ip=`STUNExternalIP | egrep 'Public IP' |  cut -d' ' -f4- | head -n 1`
      printf "My ip : $my_ip\n"

      if [ -z "$my_ip" ]; then
        echo "\$my_ip is empty"
        exit 1
      fi

     var=`echo "$DOMAINS" | sed "s/ \+/;/g"     
     printf "var =$var\n" `
     while [ "$var" ] ;do
     iter=${var%%;*}
     [ "$var" = "$iter" ] && \
         var='' || \
         var="${var#*;}"
         
         domain_ip=`ping -c 3 $iter | grep -o "([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*)" | head -n 1 | grep -o "[^()]*"`
         printf "Domain $iter has ip : $domain_ip\n"

        if [ $domain_ip !=  $my_ip ]; then
          echo "IP addresses not match."
          exit 1
        fi
     done
  else
      #echo "Internet isn't present"
      :
  fi
done
