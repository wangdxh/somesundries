#!/bin/bash


systemctl stop ceph-mgr@node2

rm -rf /var/lib/ceph/mgr/ceph-node2
ceph --cluster ceph auth get-or-create mgr.node2 mon 'allow profile mgr' osd 'allow *' mds 'allow *'  

mkdir /var/lib/ceph/mgr/ceph-node2/
ceph --cluster ceph auth get-or-create mgr.node2 -o /var/lib/ceph/mgr/ceph-node2/keyring  
systemctl start ceph-mgr@node2



