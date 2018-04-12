mkdir -p /srv
useradd swift

for ((i=1; i<=4; i ++))  
do  
    echo loop$i  
    truncate -s 5GB /srv/swift-disk$i
    mkfs.xfs -f /srv/swift-disk$i
    mkdir /mnt/sdb$i    
    mount -t xfs -o loop,noatime,nodiratime,logbufs=8 /srv/swift-disk$i /mnt/sdb$i
    mkdir /mnt/sdb$i/$i
    chown -R swift:swift /mnt/sdb$i/$i
    ln -s /mnt/sdb$i/$i /srv/$i
    mkdir -p /srv/$i/node/sdb$i
    chown -R swift:swift /srv/$i/ 
done  
mkdir -p /var/run/swift
chown -R swift:swift /var/run/swift


