#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 aarch32|aarch64"
    exit 0
fi

if [ "$1" == "aarch32" ]; then
    target=arm-linux-gnueabihf
elif [ "$1" == "aarch64" ]; then
    target=aarch64-linux-gnu 
else 
    echo "Unknown architecture. Choose either 'aarch32' or 'aarch64'"
    exit 1
fi

arch=$1

./$arch/build.sh

container=$(docker run -d $arch-installed \
    bash -c "tar zcf RPi3-staging.tar.gz RPi3-staging & \
             tar zcf RPi3-sysroot.tar.gz RPi3-sysroot & \
             tar zcf x-tools.tar.gz x-tools & \
             wait")
echo $container
status=$(docker wait $container)
if [ $status -ne 0 ]; then
    echo "Error creating toolchain archives"
    exit 1
fi
docker cp $container:/home/develop/RPi3-staging.tar.gz ../RPi3-staging-$arch.tar.gz
docker cp $container:/home/develop/RPi3-sysroot.tar.gz ../RPi3-sysroot-$arch.tar.gz
docker cp $container:/home/develop/x-tools.tar.gz ../x-tools-$arch.tar.gz
docker rm $container > /dev/null