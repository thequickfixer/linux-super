#!/bin/bash

# Variables
input=""
loginman=""
kernelver=""

# Other
ver=0.0.3
location=`pwd`
kernelname=-super
WORKDIR=$location/linux-super-work
kernelworkdir=/usr/src/linux-$kernelver

echo -ne "\nWelcome to the linux-super installer v$ver"

while ! [ -x "$(command -v $loginman)" ]; do
    echo -ne "\nPlease enter your preferred privilege escalation manager\n(doas or sudo)?\n"
    read -p "> " loginman
done

mkdir linux-super-work
cd $WORKDIR
while [[ !(-f "linux-$kernelver.tar.xz") ]]; do #while the file does not exist on disk
    echo -ne "\nWhat kernel version?\n(Note: 5.14.21 is the kernel default)\n"
    read -p "> " kernelver
    wget --no-clobber https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-$kernelver.tar.xz
    if [[ !(-f "linux-$kernelver.tar.xz") ]]; then #tell the user something went wrong
        echo "Could not find that version! Check for typos and try again."
    fi
done

while ! [ -x "$(command -v $input)" ]; do
    echo -ne "\nPerform extraction of linux-$kernelver\n(y or n)?\n"
    read -p "> " input   
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nPerforming extraction..."
    elif [ $input == "n" ]; then
    exit
    fi
done
$loginman tar -xvf linux-$kernelver.tar.xz -C /usr/src/
cd $kernelworkdir
if [ $kernelver == "5.14.21" ]; then
    #TODO: apply 5.14.21-specific patches
    echo -ne "Applied 5.14.21 specific patches"
elif [ $kernelver != "5.14.21" ]; then
    #APPLY GENERAL PATCHES (Hopefully it works lol)
    echo -ne "Applied general patches"
fi
