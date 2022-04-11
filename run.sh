#!/bin/bash

# Variables
input=""
inputdone="false"
loginman=""
kernelver=""
physical_cpu_amount=`grep -c ^processor /proc/cpuinfo`

# Other
ver=0.2.2
location=`pwd`
savedlocation=$location
kernelname=-super
WORKDIR=$location/linux-super-work
validNum='^[0-9]+$'
t_mb=$(free -m | awk '/^Mem:/{print $2}')

# Exported variables
# GCC commands go here!
# Assembly flags
export KBUILD_AFLAGS="-D__ASSEMBLY__ -g0 -ggdb0 -gstabs0 -fdevirtualize-speculatively -mtls-dialect=gnu2 -ftree-loop-vectorize -fno-rounding-math -fexcess-precision=fast -fvect-cost-model=dynamic -fipa-pta -fipa-cp-clone -fgcse -fgcse-after-reload -fversion-loops-for-strides -fno-signaling-nans -fsched-pressure -fisolate-erroneous-paths-attribute -ftree-vectorize -fira-hoist-pressure -fira-loop-pressure -ftree-coalesce-vars -ftree-loop-distribution -floop-interchange -fivopts -fpredictive-commoning -fweb -frename-registers -fpeel-loops -faggressive-loop-optimizations -ftree-partial-pre -fstdarg-opt -pipe"
# Cflags
export KBUILD_CFLAGS="-fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE -std=gnu89 -g0 -ggdb0 -gstabs0 -fdevirtualize-speculatively -mtls-dialect=gnu2 -fuse-ld=bfd -ftree-loop-vectorize -fno-rounding-math -fexcess-precision=fast -fvect-cost-model=dynamic -fipa-pta -fipa-cp-clone -fgcse -fgcse-after-reload -fversion-loops-for-strides -fno-signaling-nans -fsched-pressure -fisolate-erroneous-paths-attribute -ftree-vectorize -fira-hoist-pressure -fira-loop-pressure -ftree-coalesce-vars -ftree-loop-distribution -floop-interchange -fivopts -fpredictive-commoning -fweb -frename-registers -fpeel-loops -faggressive-loop-optimizations -ftree-partial-pre -fstdarg-opt -pipe"
# CPPflags
export KBUILD_CPPFLAGS="-D__KERNEL__ -g0 -ggdb0 -gstabs0 -fdevirtualize-speculatively -mtls-dialect=gnu2 -ftree-loop-vectorize -fno-rounding-math -fexcess-precision=fast -fvect-cost-model=dynamic -fipa-pta -fipa-cp-clone -fgcse -fgcse-after-reload -fversion-loops-for-strides -fno-signaling-nans -fsched-pressure -fisolate-erroneous-paths-attribute -ftree-vectorize -fira-hoist-pressure -fira-loop-pressure -ftree-coalesce-vars -ftree-loop-distribution -floop-interchange -fivopts -fpredictive-commoning -fweb -frename-registers -fpeel-loops -faggressive-loop-optimizations -ftree-partial-pre -fstdarg-opt -pipe"

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
if [ $kernelver == "5.14.21" ] || [ $kernelver == "5.14.20" ] || [ $kernelver == "5.14.19" ] || [ $kernelver == "5.14.18" ] || [ $kernelver == "5.14.17" ] || [ $kernelver == "5.14.16" ] || [ $kernelver == "5.14.15" ] || [ $kernelver == "5.14.14" ] || [ $kernelver == "5.14.13" ] || [ $kernelver == "5.14.12" ] || [ $kernelver == "5.14.11" ] || [ $kernelver == "5.14.10" ] || [ $kernelver == "5.14.9" ] || [ $kernelver == "5.14.8" ] || [ $kernelver == "5.14.7" ] || [ $kernelver == "5.14.6" ] || [ $kernelver == "5.14.5" ] || [ $kernelver == "5.14.4" ] || [ $kernelver == "5.14.3" ] || [ $kernelver == "5.14.2" ] || [ $kernelver == "5.14.1" ]; then
    #TODO: apply 5.14.21-specific patches
    while [ $inputdone != "true" ]; do
        echo -ne "\nApply the BMQ/PDS scheduler patch? (y/n)\n"
        read -p "> " input
        if [ $input == "y" ] || [ $input == "" ]; then
            echo -ne "\nApplying the BMQ/PDS scheduler patch"
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
elif [ $kernelver != "5.14.21" ]; then
    #APPLY GENERAL PATCHES (Hopefully it works lol)
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
    echo -ne "\nUser has enough ram to generate the kernel, Above 2048MB"
    else
    echo -ne "\nWARNING: USER MAY NOT HAVE ENOUGH RAM! Below 2048MB\n"
    read -p "Press enter to resume..."
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
