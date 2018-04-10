#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo $DIR

TargetServerIP="%s"
TargetServerPort="%s"
ProxyPort="%s"

ClientWritePath="%s"
ClientReadPath="%s"
TempFilePath="%s"
ps -fe| grep "./clientproxy $TargetServerIP:$TargetServerPort $ProxyPort" | grep -v grep
if [ $? -ne 0 ]
then
echo "start process"
./clientproxy  $TargetServerIP":"$TargetServerPort $ProxyPort $ClientWritePath  $ClientReadPath $TempFilePath > client.log &
else
echo "runing....."
fi
