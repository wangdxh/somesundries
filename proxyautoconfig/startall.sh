#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  
cd $DIR  
echo $DIR 
/root/wxh/bin_tcp9900\startclient.sh
/root/wxh/bin_tcp9907\startclient.sh
/root/wxh/bin_udp9908\startclient.sh