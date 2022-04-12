#!/bin/bash

# Variables
input=""
inputdone="false"
loginman=""
kernelver=""
debug_make=""
physical_cpu_amount=`grep -c ^processor /proc/cpuinfo`
# VV for 5.18+ kernels
gnuver=""


# Other
ver=0.2.3.4
location=`pwd`
savedlocation=$location
kernelname=-super
WORKDIR=$location/linux-super-work
validNum='^[0-9]+$'
t_mb=$(free -m | awk '/^Mem:/{print $2}')

# Functions
# Clear input
function clr_input() {
    inputdone="false"
    input=""
}  

echo -ne "\nWelcome to the linux-super installer v$ver"

while ! [ -x "$(command -v $loginman)" ]; do
    echo -ne "\nPlease enter your preferred privilege escalation manager\n(doas or sudo)?\n"
    read -p "> " loginman
done

while [ $inputdone != "true" ]; do
    echo -ne "\nEnable script debugging (y or n)?\n"
    read -p "> " input
    if [ $input == "y" ] || [ $input == "" ]; then
        echo -ne "\nEnabling debugging for script."
        debug_make="-n"
        inputdone="true"
    elif [ $input == "n" ]; then
        echo -ne "\nuser selected no"
        inputdone="true"
    fi
done
clr_input

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

if [ ! -d "/etc/sysctl.d/override.conf" ]; then
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply sysctl patches? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nPerforming patches..."
            $loginman cp $savedlocation/linux-super-patches/sysctl/override.conf /etc/sysctl.d/
            echo -ne "Applied sysctl patch for next reboot"
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "\nuser selected no"
            inputdone="true"
        fi
    done
fi
clr_input

if [ ! -d "/usr/src/linux-$kernelver" ]; then
    while [ $inputdone != "true" ]; do
        echo -ne "\nPerform extraction of linux-$kernelver\n(y or n)?\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nPerforming extraction..."
            $loginman tar -xvf linux-$kernelver.tar.xz -C /usr/src/
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "Exiting..\n"
            inputdone="true"
            exit
        fi
    done
fi
clr_input

echo -ne "\nResuming this will:"
echo -ne "\n- Add patches\n"
read -p "Press enter to resume..."

cd /usr/src/linux-$kernelver
if [[ $kernelver =~ ^(5.14.21|5.14.20|5.14.19|5.14.18|5.14.17|5.14.16|5.14.15|5.14.14|5.14.13|5.14.12|5.14.11|5.14.10|5.14.9|5.14.8|5.14.7|5.14.6|5.14.5|5.14.4|5.14.3|5.14.2|5.14.1)$ ]]; then
    #TODO: apply 5.14.21-specific patches
    gnuver="-std=gnu89"
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply the GCC optimizations patch? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying the GCC optimization patch"
            $loginman patch -N -p1 < $savedlocation/linux-super-patches/5.14/makefile/makefile-1.patch Makefile
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply the BMQ/PDS scheduler patch? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying the BMQ/PDS scheduler patch\n"
            $loginman patch -N -p1 < $savedlocation/linux-super-patches/5.14/tkg/projectc/prjc_v5.14-r3.patch
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply the TkG patches? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying the TkG patches"
            for i in $savedlocation/linux-super-patches/5.14/tkg/*.patch; 
                do $loginman patch -N -p1 < $i; 
            done
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply graysky's uarches patch? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying the uarch patch"
            for i in $savedlocation/linux-super-patches/5.14/graysky/*.patch; 
                do $loginman patch -N -p1 < $i; 
            done
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply clearlinux patches? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying clearlinux patches"
            for i in $savedlocation/linux-super-patches/clearlinux/*.patch; 
                do $loginman patch -N -p1 < $i; 
            done
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nAttempt to apply high resolution timer patches? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nAttempting to apply high resoultion timer patches..."
            for i in $savedlocation/linux-super-patches/5.14/ck-hrtimer/*.patch; 
                do $loginman patch -N -p1 < $i; 
            done
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply user patches? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying user patches"
            for i in $savedlocation/linux-super-usr-patches-def/*.patch; 
                do $loginman patch -N -p1 < $i; 
            done
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    echo -ne "\nApplied 5.14.xx specific patches"
else
     #APPLY GENERAL PATCHES (Hopefully it works lol)
     while [ $inputdone != "true" ]; do
        echo -ne "\n(REQUIRED ONLY 5.18-rc1+ (2022-) KERNELS!!) Apply gnu11 patch (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying the gnu11 patch"
            echo -ne "\nWARNING: This means you understand your kernel is after 5.18-rc1 released."
            gnuver="-std=gnu11"
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            echo -ne "\nWARNING: This means you understand your kernel is before 5.18-rc1 released."
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply uarch patches? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying the uarch patch"
            for i in $savedlocation/linux-super-patches/graysky/*.patch; 
                do $loginman patch -N -p1 < $i; 
            done
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply clearlinux patches? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying clearlinux patches"
            for i in $savedlocation/linux-super-patches/clearlinux/*.patch; 
                do $loginman patch -N -p1 < $i; 
            done
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nAttempt to apply high resolution timer patches? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nAttempting to apply high resoultion timer patches..."
            for i in $savedlocation/linux-super-patches/5.14/ck-hrtimer/*.patch; 
                do $loginman patch -N -p1 < $i; 
            done
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply user patches? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying user patches"
            for i in $savedlocation/linux-super-usr-patches/*.patch; 
                do $loginman patch -N -p1 < $i; 
            done
            inputdone="true"
        elif [ $input == "n" ]; then
            echo -ne "user selected no\n"
            inputdone="true"
        fi
    done
    clr_input
fi

#Let the user know they might not have enough ram <2GB
if [ $t_mb -gt "2048" ]; then
    echo -ne "\nUser has enough ram to generate the kernel, Above 2048MB\n"
    else
    echo -ne "\nWARNING: USER MAY NOT HAVE ENOUGH RAM! Below 2048MB\n"
    read -p "Press enter to resume..."
fi

if [ -d -a "/usr/src/linux-$kernelver/.config" ]; then
    $loginman make menuconfig
fi

if [ ! -d -a "/usr/src/linux-$kernelver/.config" ]; then
    $loginman cp $savedlocation/linux-super-patches/defaults/config /usr/src/linux-$kernelver/.config
    $loginman make menuconfig
    $loginman make oldconfig && $loginman make prepare
fi

echo -ne "\nWARNING! Resuming this will:"
echo -ne "\n- build the kernel"
echo -ne "\n- build the kernel modules and install them"
echo -ne "\n- dracut building the initramfs"
echo -ne "\n- grub-mkconfig generating the kernels\n"
read -p "Press enter to resume..."

# TODO: force program to quit if ctrl-c below

$loginman make $debug_make -j$physical_cpu_amount
$loginman make modules_install && $loginman make install
$loginman dracut --hostonly --force --kver $kernelver
$loginman grub-mkconfig -o /boot/grub/grub.cfg
