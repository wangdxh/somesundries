#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo $DIR

TargetServerIP="%s"
TargetServerPort="%s"
ProxyPort="%s"

PROCESS2=`ps -ef|grep "./clientproxy $TargetServerIP:$TargetServerPort $ProxyPort" |grep -v grep|grep -v PPID|awk '{ print $2}'`
for i in $PROCESS2
do
  echo "Kill the clientproxy process [ $i ]"
  kill -9 $i
done

