#!/bin/bash

for ((i=0; i<=7; i ++))
do
    ceph osd out $i
    systemctl stop ceph-osd@$i
    ceph osd crush remove osd.$i
    ceph auth del osd.$i
    ceph osd rm $i
    umount /var/lib/ceph/osd/ceph-$i
done

rm -rf /srv/*

losetup -D
