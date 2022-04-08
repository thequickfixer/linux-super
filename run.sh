#!/bin/bash

# Variables
ver=0.0.2
location=`pwd`
kernelname=-super
# End of variables

echo -ne "\nWelcome to the linux-super installer v$ver"

echo -ne "\nPlease enter your preferred privilege escalation manager\n(doas or sudo)?\n" 

read -p "> " loginman

echo -ne "\nWhat kernel version?\n(Note: 5.14.21 is the kernel default)\n" 

read -p "> " kernelver

if [ $kernelver == 5.14.21 ]; then
    echo "Download?"
    read -p "> " input
else
    echo "Using unknown kernel $kernelver"
fi

echo "don't forget to delete the .tar.xz"
echo "end of program"
