#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  
cd $DIR  
echo $DIR 
/root/wxh/bin_tcp9900\killclient.sh
/root/wxh/bin_tcp9907\killclient.sh
/root/wxh/bin_udp9908\killclient.sh