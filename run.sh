#!/bin/bash

# Variables
input=""
inputdone="false"
loginman=""
kernelver=""
debug_make=""
physical_cpu_amount=`grep -c ^processor /proc/cpuinfo`

# Other
ver=0.2.3.8
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

function get_patch_input() {
    local inputdone="false"; local input=""
    local prompt=$1; local toPatch=$2; local msg=$3
    while [ $inputdone == "false" ]; do
        echo -ne $prompt
        read -p "> " input
        if [[ $input =~ ^(y|Y|yes|Yes|"")$ ]]; then
            echo -ne "User answered $input"
            echo -ne $msg
            for i in $savedlocation/$toPatch
                do $loginman patch -N -p1 < $i
            done
            inputdone="true"
        elif [[ $input =~ ^(n|N|no|No)$ ]]; then
            echo -ne "User answered NO\n"
            inputdone="true"
        fi
    done
}

function get_input() {

local inputdone="false"
local input=""

while [ $inputdone != "true" ]; do
    echo -ne $1
    read -p "> " input
    if [[ $input =~ ^(Y|y|yes|YES|"")$ ]]; then
        echo -ne "\nuser selected $input"
        $2
	$3
        inputdone="true"
    else
        echo -ne "\nuser selected no"
        inputdone="true"
    fi
done

}

function if_not_dir() {

if [ ! -d $1 ]; then
    get_input "$2" "$3" "$4"
fi

}

function memory_check() {
if [ $t_mb -gt "2048" ]; then
    echo -ne "\nUser has enough ram to generate the kernel, Above 2048MB\n"
    else
    echo -ne "\nWARNING: USER MAY NOT HAVE ENOUGH RAM! Below 2048MB\n"
    read -p "Press enter to resume..."
fi
}

echo -ne "\nWelcome to the linux-super installer v$ver"

while ! [ -x "$(command -v $loginman)" ]; do
    echo -ne "\nPlease enter your preferred privilege escalation manager\n(doas or sudo)?\n"
    read -p "> " loginman
done

get_input "\nEnable script debugging (y or n)?\n" "export debug_make="-n""

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

if_not_dir "/etc/sysctl.d/override.conf" "\nApply sysctl patches? (y/n)\n" "$loginman cp $savedlocation/linux-super-patches/sysctl/override.conf /etc/sysctl.d/"

if_not_dir "/usr/src/linux-$kernelver-super" "\nPerform extraction of linux-$kernelver\n(y or n)?\n" "tar -xvf linux-$kernelver.tar.xz -C $WORKDIR" "$loginman cp -r linux-$kernelver/ /usr/src/linux-$kernelver-super"

echo -ne "\nResuming this will:"
echo -ne "\n- Add patches\n"
read -p "Press enter to resume..."

cd /usr/src/linux-$kernelver-super
if [[ $kernelver =~ ^(5.14.21|5.14.20|5.14.19|5.14.18|5.14.17|5.14.16|5.14.15|5.14.14|5.14.13|5.14.12|5.14.11|5.14.10|5.14.9|5.14.8|5.14.7|5.14.6|5.14.5|5.14.4|5.14.3|5.14.2|5.14.1)$ ]]; then
    
    get_input "\nApply the GCC optimizations patch?\n (NOT RECOMMENDED UNLESS YOU'RE CERTAIN YOU KNOW WHAT YOU'RE DOING!!!)\n (y/n)\n" "$loginman patch -N -p1 Makefile $savedlocation/linux-super-patches/5.14/makefile/makefile-1.patch"

    get_patch_input "\nApply the BMQ/PDS scheduler patch? (y/n)\n" "linux-super-patches/5.14/tkg/projectc/*.patch" "\nApplying BMQ/PDS patches"
    
    get_patch_input "\nApply the TkG patches? (y/n)\n" "linux-super-patches/5.14/tkg/*.patch" "\nApplying the TkG patches"
    
    get_patch_input "\nApply graysky's uarches patch? (y/n)\n" "linux-super-patches/5.14/graysky/*.patch" "\nApplying graysky's uarch patch"
    
    get_patch_input "\nApply clearlinux patches? (y/n)\n" "linux-super-patches/clearlinux/*.patch" "\nApplying clearlinux patches"
    
    get_patch_input "\nApply Intel Alder-lake ITMT patch?\n (NOT RECOMMENDED APPLY AT OWN RISK!!!)\n (y/n)\n" "linux-super-patches/5.14/intel/*.patch" "\nApplying Intel Alder-lake ITMT patch"
    
    get_patch_input "\nAttempt to apply high resolution timer patches? (y/n)\n" "linux-super-patches/5.14/ck-hrtimer/*.patch" "\nAttemping to apply high resolution timer patches..."
    
    get_patch_input "\nApply user patches? (y/n)\n" "linux-super-usr-patches-def/*.patch" "\nApplying user patches"
    
    echo -ne "\nApplied 5.14.xx specific patches"
    
else
    
    get_patch_input "\nApply graysky's uarch patch? (y/n)\n" "linux-super-patches/graysky/*.patch" "\nApplying graysky's uarch patch"
    
    get_patch_input "\nApply clearlinux patches? (y/n)\n" "linux-super-patches/clearlinux/*.patch" "\nApplying clearlinux patches"
    
    get_patch_input "\nAttempt to apply high resolution timer patches? (y/n)\n" "linux-super-patches/5.14/ck-hrtimer/*.patch" "\nAttempting to apply high resoultion timer patches..."
    
    get_patch_input "\nApply user patches? (y/n)\n" "linux-super-usr-patches/*.patch" "\nApplying user patches"

fi

#Let the user know they might not have enough ram <2GB
memory_check

#saves user config for next time and lets user choose if exist
if ! [ -a /usr/src/linux-$kernelver-super/.config ]; then
    $loginman cp -rf $savedlocation/linux-super-patches/defaults/config /usr/src/linux-$kernelver-super/.config
else
    get_input "\n Overwrite .config (resets user config to default) (y/n)?\n" "$loginman cp -rf $savedlocation/linux-super-patches/defaults/config /usr/src/linux-$kernelver-super/.config"
fi

$loginman make menuconfig

echo -ne "\nWARNING! Resuming this will:"
echo -ne "\n- build the kernel"
echo -ne "\n- build the kernel modules and install them"
echo -ne "\n- dracut building the initramfs"
echo -ne "\n- grub-mkconfig generating the kernels\n"
read -p "Press enter to resume..."

# TODO: force program to quit if ctrl-c below

$loginman make $debug_make -j$physical_cpu_amount
$loginman make modules_install
$loginman make install
$loginman dracut --hostonly --no-compress --force --kver $kernelver-super
$loginman grub-mkconfig -o /boot/grub/grub.cfg
