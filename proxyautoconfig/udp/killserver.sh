#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo $DIR

TargetServerIP="%s"
TargetServerPort="%s"
ProxyPort="%s"

PROCESS=`ps -ef|grep "./udpserverproxy $TargetServerIP:$TargetServerPort $ProxyPort" |grep -v grep|grep -v PPID|awk '{ print $2}'`
for i in $PROCESS
do
  echo "Kill the udpserverproxy process [ $i ]"
  kill -9 $i
done

