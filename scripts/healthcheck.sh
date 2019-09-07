#!/bin/sh

failed=0
while sleep $(( $INTERVAL*60 )); do

  if [[ "$(ping -c 1 8.8.8.8 | grep '0% packet loss' )" != "" ]]; then
      #echo "Internet is present"

      my_ip=`STUNExternalIP | egrep 'Public IP' |  cut -d' ' -f4- | head -n 1`
      printf "My ip : $my_ip\n"

      if [ -z "$my_ip" ]; then
        echo "\$my_ip is empty"
        exit -1
      fi

     var=`echo "$DOMAINS" | sed "s/ \+/;/g"      `
     while [ "$var" ] ;do
     iter=${var%%;*}
     [ "$var" = "$iter" ] && \
         var='' || \
         var="${var#*;}"

         echo "> [$iter]"
         
         domain_ip=`ping -c 3 $iter | grep -o "([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*)" | head -n 1 | grep -o "[^()]*"`
         printf "Domain $iter has ip : $domain_ip\n"

        if [ $domain_ip !=  $my_ip ]; then
          
          echo "Strings are not equal"

          if [ $failed -ne 0 ]; then
            echo "Retry failed, exiting."
            exit -1
          fi

          failed=1
          sleep $(( $INTERVAL*200 ))
        fi
     done
  else
      #echo "Internet isn't present"
      :
  fi
done
