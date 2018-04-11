for ((i=0; i<=4; i ++))  
do  
    echo /opt/d$i  
    mkdir -p /srv/node/d$i
    dd if=/dev/zero of=/opt/d$i bs=1M count=0 seek=5000
    mkfs.xfs -f /opt/d$i
    mount -t xfs -o noatime,nodiratime,logbufs=8 /opt/d$i /srv/node/d$i
done  
useradd swift
chown -R swift:swift /srv/node
