#!/bin/bash

ver=0.0.1
location=$pwd

echo
echo "Welcome to the linux-super installer v$ver"
echo
echo "Please enter your preferred login as manager (doas or sudo)"
echo
read -p "> " loginman
echo 
echo "Set preferred login as $loginman"
echo
echo $location
