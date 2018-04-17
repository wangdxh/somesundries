mkdir -p /srv
useradd swift

for ((i=1; i<=4; i ++))  
do  
    echo loop$i  
    truncate -s 4GB /srv/swift-disk$i
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


rm -rf /etc/swift
mkdir -p /etc/swift

cd $HOME/swift/doc
cp -r saio/swift/* /etc/swift
cd 
chown -R swift:swift /etc/swift

find /etc/swift/ -name \*.conf | xargs sudo sed -i "s/<your-user-name>/swift/"

/usr/bin/cp -f $HOME/swift/doc/saio/rsyncd.conf /etc/
sed -i "s/<your-user-name>/swift/" /etc/rsyncd.conf

echo "disable = no" >>  /etc/xinetd.d/rsync
setenforce Permissive

systemctl restart xinetd.service
systemctl enable rsyncd.service
systemctl start rsyncd.service
rsync rsync://pub@localhost/
systemctl enable memcached.service
systemctl start memcached.service



