#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [ "$#" -ne 1 ]; then
    echo "Build and export the Raspberry Pi GCC toolchain and cross-compiled libraries."
    echo
    echo "Usage: $0 aarch32|aarch64|aarch64-dev"
    echo
    exit 0
fi

name="$1"
case "$name" in
aarch32)
    echo "aarch32 (without development tools)"
    target=arm-linux-gnueabihf
    arch=aarch32
    image=aarch32-python-opencv-cross
    ;;
aarch64)
    echo "aarch64 (without development tools)"
    target=aarch64-linux-gnu
    arch=aarch64
    image=aarch64-python-opencv-cross
    ;;
aarch64-dev)
    echo "aarch64 (with development tools)"
    target=aarch64-linux-gnu
    arch=aarch64
    image=aarch64-develop-cross
    ;;
*)
    echo "Unknown option."
    echo "Choose either 'aarch32', 'aarch64', 'aarch64-develop'."
    exit 1
    ;;
esac

./$arch/build.sh

container=$(docker run -d $image \
    bash -c "tar zcf RPi3-staging.tar.gz RPi3-staging & \
             tar zcf RPi3-sysroot.tar.gz RPi3-sysroot & \
             tar zcf x-tools.tar.gz x-tools & \
             wait")
status=$(docker wait $container)
if [ $status -ne 0 ]; then
    echo "Error creating toolchain archives"
    exit 1
fi
docker cp $container:/home/develop/RPi3-staging.tar.gz ../RPi3-staging-$name.tar.gz
docker cp $container:/home/develop/RPi3-sysroot.tar.gz ../RPi3-sysroot-$name.tar.gz
docker cp $container:/home/develop/x-tools.tar.gz ../x-tools-$arch.tar.gz
docker rm $container >/dev/null
