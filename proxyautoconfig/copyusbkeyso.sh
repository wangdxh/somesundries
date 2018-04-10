#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo $DIR

chmod -R 777 ./lib
chmod -R 777 ./lib64

/bin/cp -fr ./lib/*.so /usr/lib
/bin/cp -fr ./lib64/*.so /usr/lib64
ldconfig
