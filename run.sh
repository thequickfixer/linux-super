#!/bin/bash

# Variables
ver=0.0.2
location=`pwd`
kernelname=-super
workdir=$location/linux-super-work
kernelworkdir=/usr/src/linux-$kernelver

# End of variables

echo -ne "\nWelcome to the linux-super installer v$ver"

echo -ne "\nPlease enter your preferred privilege escalation manager\n(doas or sudo)?\n" 

read -p "> " loginman

echo -ne "\nWhat kernel version?\n(Note: 5.14.21 is the kernel default)\n" 

read -p "> " kernelver

if [ $kernelver == 5.14.21 ]; then
    echo "Download?"
    read -p "> " input
    if [ $input == y ]; then
        mkdir linux-super-work
        cd $workdir
        wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-$kernelver.tar.xz
        if [ ! -d "$workdir/linux-$kernelver.tar.xz" ]; then
            echo "no kernel version"
        else
        echo "Extract the files?"
        if [ ! -d "$kernelworkdir" ]; then
            $loginman tar -xvf linux-$kernelver.tar.xz -C /usr/src/
        else

else
    echo "Using unknown kernel $kernelver"
fi

echo "don't forget to delete the .tar.xz"
echo "end of program"
