#!/bin/bash

# change ceph to root
#find /usr/lib/systemd/system -name "ceph-*.service" | xargs sed -i 's/--setuser ceph --setgroup ceph/ /g'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo $DIR

systemctl stop ceph-mon@node2


rm -rf /etc/ceph/ceph.conf

rm -rf /etc/ceph/ceph.*.keyring
rm -rf /tmp/ceph.*.keyring

cp ./ceph.conf /etc/ceph/ceph.conf

ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'  
  
ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'  
ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring  
  

ceph-authtool --create-keyring /etc/ceph/ceph.client.bootstrap-osd.keyring --gen-key -n client.bootstrap-osd --cap mon 'allow profile bootstrap-osd'  
ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.bootstrap-osd.keyring  

rm -f /tmp/monmap
monmaptool --create --add node2 172.19.2.97 --fsid 7ea7741f-c0fa-477e-b0a3-11af8080bad2 /tmp/monmap 
monmaptool --print /tmp/monmap

rm -rf /var/lib/ceph/mon/ceph-node2/* 
ceph-mon --cluster ceph --mkfs -i node2 --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring  
ls -al  /var/lib/ceph/mon/ceph-node2

touch /var/lib/ceph/mon/ceph-node2/done 

chown -R ceph:ceph /var/lib/ceph/*
chown -R ceph:ceph /etc/ceph/*

systemctl start ceph-mon@node2
sleep 2
ps aux | grep ceph




