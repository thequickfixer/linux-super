#!/bin/bash

# Variables
input=""
loginman=""
kernelver=""
physical_cpu_amount=`grep -c ^processor /proc/cpuinfo`

# Other
ver=0.1.6
location=`pwd`
savedlocation=$location
kernelname=-super
WORKDIR=$location/linux-super-work
validNum='^[0-9]+$'
t_mb=$(free -m | awk '/^Mem:/{print $2}')

# Exported variables
# GCC commands go here!
export KBUILD_AFLAGS= -D__ASSEMBLY__ -O2 -g0 -ggdb0 -gstabs0 -fdevirtualize-speculatively -mtls-dialect=gnu2 -fuse-ld=bfd -ftree-loop-vectorize -fno-rounding-math -fexcess-precision=fast -fvect-cost-model=dynamic -fipa-pta -fipa-cp-clone -fgcse -fgcse-after-reload -fversion-loops-for-strides -fno-signaling-nans -fsched-pressure -fisolate-erroneous-paths-attribute -ftree-vectorize -fira-hoist-pressure -fira-loop-pressure -ftree-coalesce-vars -ftree-loop-distribution -floop-interchange -fivopts -fpredictive-commoning -fweb -frename-registers -fpeel-loops -faggressive-loop-optimizations -ftree-partial-pre -fstdarg-opt -pipe
# Cflag
export KBUILD_CFLAGS= -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -std=gnu89 -O2 -g0 -ggdb0 -gstabs0 -fdevirtualize-speculatively -mtls-dialect=gnu2 -fuse-ld=bfd -ftree-loop-vectorize -fno-rounding-math -fexcess-precision=fast -fvect-cost-model=dynamic -fipa-pta -fipa-cp-clone -fgcse -fgcse-after-reload -fversion-loops-for-strides -fno-signaling-nans -fsched-pressure -fisolate-erroneous-paths-attribute -ftree-vectorize -fira-hoist-pressure -fira-loop-pressure -ftree-coalesce-vars -ftree-loop-distribution -floop-interchange -fivopts -fpredictive-commoning -fweb -frename-registers -fpeel-loops -faggressive-loop-optimizations -ftree-partial-pre -fstdarg-opt -pipe
# CPPflags
export KBUILD_CPPFLAGS= -D__KERNEL__ -O2 -g0 -ggdb0 -gstabs0 -fdevirtualize-speculatively -mtls-dialect=gnu2 -fuse-ld=bfd -ftree-loop-vectorize -fno-rounding-math -fexcess-precision=fast -fvect-cost-model=dynamic -fipa-pta -fipa-cp-clone -fgcse -fgcse-after-reload -fversion-loops-for-strides -fno-signaling-nans -fsched-pressure -fisolate-erroneous-paths-attribute -ftree-vectorize -fira-hoist-pressure -fira-loop-pressure -ftree-coalesce-vars -ftree-loop-distribution -floop-interchange -fivopts -fpredictive-commoning -fweb -frename-registers -fpeel-loops -faggressive-loop-optimizations -ftree-partial-pre -fstdarg-opt -pipe

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

if [ ! -d "/usr/src/linux-$kernelver" ]; then
  echo -ne "\nPerform extraction of linux-$kernelver\n(y or n)?\n"
  read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nPerforming extraction..."
        $loginman tar -xvf linux-$kernelver.tar.xz -C /usr/src/
    elif [ $input == "n" ]; then
        echo -ne "Exiting..\n"
        exit
    fi
fi

# reset input
input=""

echo -ne "\nResuming this will:"
echo -ne "\n- Add patches\n"
read -p "Press enter to resume..."

cd /usr/src/linux-$kernelver
if [ $kernelver == "5.14.21" ]; then
    #TODO: apply 5.14.21-specific patches
    echo -ne "\nApply the BFQ/PDS scheduler patch? (y/n)\n"
    read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nApplying the BFQ/PDS scheduler patch"
        for i in $savedlocation/linux-super-patches/5.14/alfred-chen/*.patch; 
            do $loginman patch -p1 < $i; 
        done
    elif [ $input == "n" ]; then
        echo -ne "user selected no\n"
    fi
    input=""
    echo -ne "\nApply graysky's uarches patch? (y/n)\n"
    read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nApplying the uarch patch"
        for i in $savedlocation/linux-super-patches/5.14/graysky/*.patch; 
            do $loginman patch -p1 < $i; 
        done
    elif [ $input == "n" ]; then
        echo -ne "user selected no\n"
    fi
    input=""
    echo -ne "\nApply clearlinux patches? (y/n)\n"
    read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nApplying clearlinux patches"
        for i in $savedlocation/linux-super-patches/clearlinux/*.patch; 
            do $loginman patch -p1 < $i; 
        done
    elif [ $input == "n" ]; then
        echo -ne "user selected no\n"
    fi
    input=""
    echo -ne "\nApply user patches? (y/n)\n"
    read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nApplying user patches"
        for i in $savedlocation/linux-super-usr-patches-def/*.patch; 
            do $loginman patch -p1 < $i; 
        done
    elif [ $input == "n" ]; then
        echo -ne "user selected no\n"
    fi
    input=""
    echo -ne "Applied 5.14.21 specific patches"
elif [ $kernelver != "5.14.21" ]; then
    #APPLY GENERAL PATCHES (Hopefully it works lol)
    echo -ne "\nApply general patches (y/n)\n"
    read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nApplying the uarch patch"
        for i in $savedlocation/linux-super-patches/*.patch; 
            do $loginman patch -p1 < $i; 
        done
    elif [ $input == "n" ]; then
        echo -ne "user selected no\n"
    fi
    input=""
    echo -ne "\nApply clearlinux patches? (y/n)\n"
    read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nApplying clearlinux patches"
        for i in $savedlocation/linux-super-patches/clearlinux/*.patch; 
            do $loginman patch -p1 < $i; 
        done
    elif [ $input == "n" ]; then
        echo -ne "user selected no\n"
    fi
    input=""
    echo -ne "\nApply user patches? (y/n)\n"
    read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nApplying user patches"
        for i in $savedlocation/linux-super-usr-patches/*.patch; 
            do $loginman patch -p1 < $i; 
        done
    elif [ $input == "n" ]; then
        echo -ne "user selected no\n"
    fi
    input=""
    echo -ne "Applied general and user patches"
fi

#Let the user know they might not have enough ram <2GB
if [ $t_mb -gt "2048" ]; then
    echo -ne "\nUser has enough ram to generate the kernel, Above 2048MB"
    else
    echo -ne "\nWARNING: USER MAY NOT HAVE ENOUGH RAM! Below 2048MB\n"
fi

$loginman make menuconfig

echo -ne "\nWARNING! Resuming this will:"
echo -ne "\n- build the kernel"
echo -ne "\n- build the kernel modules and install them"
echo -ne "\n- dracut building the initramfs"
echo -ne "\n- grub-mkconfig generating the kernels\n"
read -p "Press enter to resume..."

# TODO: force program to quit if ctrl-c below

$loginman make -j$physical_cpu_amount
$loginman make modules_install && $loginman make install
$loginman dracut --hostonly --force --kver $kernelver
$loginman grub-mkconfig -o /boot/grub/grub.cfg
