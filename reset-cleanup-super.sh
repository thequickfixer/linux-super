#!/bin/bash

# This script basically cleans up the stuff that's leftover from previous install, except for the ones in /boot/

# Variables
loginman=""
ver=0.0.0.1

#Other
location=`pwd`
savedlocation=$location
WORKDIR=$location/linux-super-work
inputdone="false"
input=""

echo -ne "\nWelcome to the linux-super cleaner v$ver"

while ! [ -x "$(command -v $loginman)" ]; do
    echo -ne "\nPlease enter your preferred privilege escalation manager\n(doas or sudo)?\n"
    read -p "> " loginman
done

while [ $inputdone != "true" ]; do
    echo -ne "\nWhat kernel version did you install?\n(Note: 5.14.21 is the kernel default)\n"
    read -p "> " input
    if [[ (-d "/usr/src/linux-$input-super") ]]; then
        echo -ne "\nFound and cleaning $input..."
        $loginman rm -rI /usr/src/linux-$input-super
        inputdone="true"
    else
        echo "Could not find version (linux-$input-super)!  Check for typos and try again or you may be trying to delete a file that doesn't exist."
    fi
done
