#!/bin/bash

#systemctl restart ceph-mon@node2

#systemctl restart ceph-mgr@node2

#sleep 5

cd /root
sh ./cleanosd.sh

sleep 10

for ((i=0; i<=0; i ++))
do
    truncate -s 4GB /srv/sd$i
    losetup /dev/loop$i /srv/sd$i
    ceph-disk prepare --cluster ceph --cluster-uuid 7ea7741f-c0fa-477e-b0a3-11af8080bad2 /dev/loop$i
    ceph-disk activate /dev/loop${i}p1 --activate-key /etc/ceph/ceph.client.bootstrap-osd.keyring 
    sleep 10
done


