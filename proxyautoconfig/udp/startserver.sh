#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo $DIR

TargetServerIP="%s"
TargetServerPort="%s"
ProxyPort="%s"

ServerWritePath="%s"
ServerReadPath="%s"
TempFilePath="%s"

ps -fe| grep "./udpserverproxy $TargetServerIP:$TargetServerPort $ProxyPort" | grep -v grep
if [ $? -ne 0 ]
then
echo "start process"
./udpserverproxy $TargetServerIP":"$TargetServerPort $ProxyPort  $ServerWritePath  $ServerReadPath $TempFilePath > udpserver.log &
else
echo "runing....."
fi
