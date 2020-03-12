#!/usr/bin/env bash

set -ex

# Download
git clone --branch bzip2-1.0.8 --depth 1 git://sourceware.org/git/bzip2.git
pushd bzip2

# Build libraries
make -f Makefile-libbz2_so -j $(($(nproc) * 2)) \
    CC="${HOST_TRIPLE}-gcc --sysroot=${RPI_SYSROOT}"

# Install libraries
cp -a libbz2.so.1.0 $RPI_SYSROOT/usr/local/lib
cp -a libbz2.so.1.0.8 $RPI_SYSROOT/usr/local/lib
ln -s libbz2.so.1.0 ${RPI_SYSROOT}/usr/local/lib/libbz2.so
cp -a libbz2.so.1.0 $RPI_STAGING/usr/local/lib
cp -a libbz2.so.1.0.8 $RPI_STAGING/usr/local/lib
ln -s libbz2.so.1.0 ${RPI_STAGING}/usr/local/lib/libbz2.so

# Build binaries
make bzip2 bzip2recover -j $(($(nproc) * 2)) \
    CC="${HOST_TRIPLE}-gcc --sysroot=${RPI_SYSROOT}"

# Install binaries
make install PREFIX="${RPI_SYSROOT}/usr/local"
make install PREFIX="${RPI_STAGING}/usr/local"

# Cleanup
popd
rm -rf bzip2