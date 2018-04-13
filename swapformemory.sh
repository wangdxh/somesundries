dd if=/dev/zero of=/swapfile bs=1k count=2048000
mkswap /swapfile
swapon /swapfile
swapon -s


# swapoff /swapfile  
# rm -fr /swapfile  

delete CMakeCache.txt文件
