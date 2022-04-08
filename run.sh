#!/bin/bash

ver=0.0.1
location=`pwd`
kernelname=-super

echo
echo "Welcome to the linux-super installer v$ver"
echo
echo "Please enter your preferred login as manager (doas or sudo)"
echo
read -p "> " loginman
echo
echo "Set preferred login as $loginman"
echo
echo "What kernel version?"
echo
echo "Note: 5.14.21 is the kernel default"
echo 
read -p "> " kernelver
if [ $kernelver == 5.14.21 ]; then
echo "Download?"
read -p "> " input
else
echo 
echo "Using unknown kernel $kernelver"
echo 
fi
echo 
echo "..."
