#!/bin/bash

rm -f /etc/ceph/ceph.client.radosgw.keyring
ceph auth get-or-create client.radosgw.gateway osd 'allow rwx' mon 'allow rwx' -o /etc/ceph/ceph.client.radosgw.keyring

ls -al /etc/ceph/ceph.client.radosgw.keyring

radosgw -c /etc/ceph/ceph.conf -n client.radosgw.gateway

