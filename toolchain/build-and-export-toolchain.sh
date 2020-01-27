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
    target=armv8-rpi3-linux-gnueabihf
    arch=aarch32
    image=aarch32-python-opencv-cross
    dev=nodev
    ;;
aarch64)
    echo "aarch64 (without development tools)"
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    image=aarch64-python-opencv-cross
    dev=nodev
    ;;
aarch64-dev)
    echo "aarch64 (with development tools)"
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    image=aarch64-develop-cross
    dev=dev
    ;;
*)
    echo "Unknown option."
    echo "Choose either 'aarch32', 'aarch64', 'aarch64-develop'."
    exit 1
    ;;
esac

./docker/$arch/build.sh "$dev"

container=$(docker run -d $image \
    bash -c "tar cf RPi3-staging.tar RPi3-staging & \
             tar cf RPi3-sysroot.tar RPi3-sysroot & \
             tar cf x-tools.tar x-tools & \
             wait")
status=$(docker wait $container)
if [ $status -ne 0 ]; then
    echo "Error creating toolchain archives"
    exit 1
fi
docker cp $container:/home/develop/RPi3-staging.tar RPi3-staging-$name.tar
docker cp $container:/home/develop/RPi3-sysroot.tar RPi3-sysroot-$name.tar
docker cp $container:/home/develop/x-tools.tar x-tools-$arch.tar
docker rm $container >/dev/null

chmod -fR u+w RPi3-sysroot-$name || :
rm -rf RPi3-sysroot-$name
mkdir RPi3-sysroot-$name
tar xf RPi3-sysroot-$name.tar -C RPi3-sysroot-$name --strip-components 1
rm RPi3-sysroot-$name.tar

chmod -fR u+w x-tools/$target || :
rm -rf x-tools/$target
tar xf x-tools-$arch.tar
rm x-tools-$arch.tar