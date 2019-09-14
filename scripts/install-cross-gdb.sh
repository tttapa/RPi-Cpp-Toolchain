#!/usr/bin/env bash

set -e

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

cd /tmp
if [ ! -e gdb-8.3.tar.xz ]; then
    wget https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.xz
fi
rm -rf gdb-8.3
tar xf gdb-8.3.tar.xz
mkdir -p gdb-8.3/build
cd gdb-8.3/build
../configure --prefix=$HOME/.local --target=$target
make -j$(nproc)
make install
