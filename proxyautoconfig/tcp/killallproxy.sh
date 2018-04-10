
#!/bin/sh
PROCESS=`ps -ef|grep serverproxy |grep -v grep|grep -v PPID|awk '{ print $2}'`
for i in $PROCESS
do
  echo "Kill the serverproxy process [ $i ]"
  kill -9 $i
done

PROCESS2=`ps -ef|grep clientproxy |grep -v grep|grep -v PPID|awk '{ print $2}'`
for i in $PROCESS2
do
  echo "Kill the clientproxy process [ $i ]"
  kill -9 $i
done

