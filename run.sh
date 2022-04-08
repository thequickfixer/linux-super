#!/bin/bash

# Variables
input=""
loginman=""
kernelver=""

# Other
ver=0.0.8
location=`pwd`
savedlocation=$location
kernelname=-super
WORKDIR=$location/linux-super-work

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
        echo "Could not find version ($kernelver)!  Check for typos and try again."
    fi
done

while ! [ -x "$(command -v $input)" ]; do
    echo -ne "\nPerform extraction of linux-$kernelver\n(y or n)?\n"
    read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nPerforming extraction..."
        $loginman tar -xvf linux-$kernelver.tar.xz -C /usr/src/
        break
    elif [ $input == "n" ]; then
        echo -ne "Exiting..\n"
        exit
    fi
done

echo -ne "\nResuming this will:"
echo -ne
read -p "Press enter to resume"

cd /usr/src/linux-$kernelver
if [ $kernelver == "5.14.21" ]; then
    #TODO: apply 5.14.21-specific patches
    $loginman patch -p1 < $savedlocation/linux-super-patches/*.patch
    $loginman patch -p1 < $savedlocation/linux-super-patches/clearlinux/*.patch
    echo -ne "Applying user patches"
    $loginman patch -p1 < $savedlocation/linux-super-usr-patches-def/*.patch
    echo -ne "Applied 5.14.21 specific patches"
elif [ $kernelver != "5.14.21" ]; then
    #APPLY GENERAL PATCHES (Hopefully it works lol)
    $loginman patch -p1 < $savedlocation/linux-super-patches/*.patch
    $loginman patch -p1 < $savedlocation/linux-super-patches/clearlinux/*.patch
    $loginman patch -p1 < $savedlocation/linux-super-usr-patches/*.patch
    echo -ne "Applied general and user patches"
fi

$loginman 
