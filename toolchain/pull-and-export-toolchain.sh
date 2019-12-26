#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"/docker

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
img="tttapa/rpi3-$arch-installed:latest"

docker pull $img
id=$(docker create $img)
docker cp $id:/home/develop/x-tools.tar.gz .. &
docker cp $id:/home/develop/RPi3-staging.tar.gz .. &
docker cp $id:/home/develop/RPi3-sysroot.tar.gz ..
wait
docker rm -v $id
cd ..
tar xzf x-tools.tar.gz &
tar xzf RPi3-sysroot.tar.gz && mv RPi3-sysroot RPi3-sysroot-$arch &
mv RPi3-staging.tar.gz RPi3-staging-$arch.tar.gz
wait
rm RPi3-sysroot.tar.gz &
rm x-tools.tar.gz
wait