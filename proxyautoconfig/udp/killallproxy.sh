
#!/bin/sh
PROCESS=`ps -ef|grep udpserverproxy |grep -v grep|grep -v PPID|awk '{ print $2}'`
for i in $PROCESS
do
  echo "Kill the udpserverproxy process [ $i ]"
  kill -9 $i
done

PROCESS2=`ps -ef|grep udpclientproxy |grep -v grep|grep -v PPID|awk '{ print $2}'`
for i in $PROCESS2
do
  echo "Kill the udpclientproxy process [ $i ]"
  kill -9 $i
done

