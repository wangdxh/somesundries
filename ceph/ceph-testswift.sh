#!/bin/bash

radosgw-admin user create --uid="myuser" --display-name="First User" | tee user.txt
radosgw-admin subuser create --subuser=myuser:swift --access=full
radosgw-admin key create --subuser=myuser:swift --key-type=swift --gen-secret | tee subuser.txt
export PASSWORD=`sed -n '/myuser:swift/{N;p;}' subuser.txt | sed -n 's/ *"secret_key": "\(.*\)"/\1/p'`

cat subuser.txt
echo $PASSWORD
