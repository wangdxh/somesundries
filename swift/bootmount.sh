#!/bin/bash
for ((i=0; i<=4; i ++))  
do  
    mount -t xfs -o noatime,nodiratime,logbufs=8 /opt/d$i /srv/node/d$i
done
