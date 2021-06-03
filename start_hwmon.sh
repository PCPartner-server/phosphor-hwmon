#!/bin/bash

action=$1
devpath=$2
of_fullname=$3
echo $1 $2 $3 >> /var/log/hwmon.log
#Use of_fullname if it's there, otherwise use devpath.

path=$of_fullname
if [ -z "$path" ]
then
    path=$devpath

    if [[ "$path" =~ (.*)/hwmon/hwmon[0-9]+$ ]];
    then
        path=${BASH_REMATCH[1]}
    fi
fi

#peci devices are also passed in here, but not every one is a valid path
if [[ $path == *"peci"* ]]; then
    if [[ $path == *"temp"* ]]; then
        echo starting $path >> /var/log/hwmon.log
    else
        echo not a valid device path $path >> /var/log/hwmon.log
        exit 0
    fi
fi

# Needed to re-do escaping used to avoid bitbake separator conflicts
path="${path//:/--}"
# Needed to escape prior to being used as a unit argument
#path="$(systemd-escape "$path")"
#systemctl --no-block "$action" "xyz.openbmc_project.Hwmon@$path.service"
systemctl --no-block "$action" "xyz.openbmc_project.Hwmon@$(systemd-escape $path).service"
