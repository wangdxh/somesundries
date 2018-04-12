#!/bin/bash
for ((i=0; i<=4; i ++))  
do  
    #mount -t xfs -o noatime,nodiratime,logbufs=8 /opt/d$i /srv/node/d$i
    mount -t xfs -o loop,noatime,nodiratime,logbufs=8 /srv/swift-disk$i /mnt/sdb$i
done

mkdir -p /var/cache/swift /var/cache/swift2 /var/cache/swift3 /var/cache/swift4
chown swift:swift /var/cache/swift*
mkdir -p /var/run/swift
chown swift:swift /var/run/swift
/opt/bin/startmain
