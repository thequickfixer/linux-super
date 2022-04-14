#!/bin/bash

# This script basically cleans up the stuff that's leftover from previous install, except for the ones in /boot/

# Variables
loginman=""
ver=0.0.0.1

#Other
location=`pwd`
savedlocation=$location
WORKDIR=$location/linux-super-work

function get_clean() {

local inputdone="false"
local input=""

while [ $inputdone != "true" ]; do
    echo -ne $1
    read -p "> " input
    if [[ (-f "/usr/src/linux-$input-super") ]]; then
        echo -ne "\nFound and cleaning $input..."
        $2
        inputdone="true"
    if [[ !(-f "/usr/src/linux-$input-super") ]]; then #tell the user something went wrong
        echo "Could not find version (linux-$input-super)!  Check for typos and try again or you may be trying to delete a file that doesn't exist."
    fi
done

}

echo -ne "\nWelcome to the linux-super cleaner v$ver"

while ! [ -x "$(command -v $loginman)" ]; do
    echo -ne "\nPlease enter your preferred privilege escalation manager\n(doas or sudo)?\n"
    read -p "> " loginman
done

get_clean "\nWhat kernel version did you install?\n(Note: 5.14.21 is the kernel default)\n" "$loginman rm -rI /usr/src/linux-$input-super"
