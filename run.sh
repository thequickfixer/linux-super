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
if [ ! -d "$kernelworkdir" ]; then {
    $loginman tar -xvf linux-$kernelver.tar.xz -C /usr/src/
    cd $kernelworkdir
    if [ $kernelver == "5.14.21" ]; then
        #TODO: apply 5.14.21-specific patches
    else
        #APPLY GENERAL PATCHES (Hopefully it works lol)
    fi
}


#if [ $kernelver == "whatever" ]; then
#   #TODO: apply whatever-specific patches
#fi



# Too scary to NOT have commented out
#if [ ! -d "$workdir/linux-$kernelver.tar.xz" ]; then
#    echo "no kernel version"
#else
#    echo "Extract the files?"
#if [ ! -d "$kernelworkdir" ]; then
#    $loginman tar -xvf linux-$kernelver.tar.xz -C /usr/src/
#fi



echo "don't forget to delete the .tar.xz"
echo "end of program"
