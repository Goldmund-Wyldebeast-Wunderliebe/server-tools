#!/bin/bash

USERS=`cat /etc/passwd|grep prd |awk -F ":" '{print $1":"$6}'`

for user_line in $USERS; do
  user=`echo $user_line| awk -F ":" '{print $1 }'`
  home=`echo $user_line| awk -F ":" '{print $2 }'`

  reboot_cron=`crontab -u $user -l | grep "@reboot"`
  if [ -n "$reboot_cron" ]; then
    file=`echo $reboot_cron|awk '{print $2}'`
    file=${file/\~/$home}

    if [[ -x $file ]]; then
      echo "Crontab OK for $user, found executable '$file'"
    else
      echo "WARNING: '$file' is not executable or found for $user"
    fi
  else
    echo "WARNING: no crontab with @reboot found for $user"
  fi
done
