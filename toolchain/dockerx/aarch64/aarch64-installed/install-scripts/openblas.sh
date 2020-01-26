#!/usr/bin/env bash

set -ex

# Download
git clone -b 'v0.3.7' --single-branch --depth 1 \
    https://github.com/xianyi/OpenBLAS


# Build
pushd OpenBLAS
make \
    CC="${HOST_TRIPLE}-gcc" \
    FC="${HOST_TRIPLE}-gfortran" \
    HOSTCC=gcc \
    TARGET=${HOST_CPU}

# Install
make install DESTDIR="${RPI3_SYSROOT}" PREFIX="/usr/local"
make install DESTDIR="${RPI3_STAGING}" PREFIX="/usr/local"

# Cleanup
popd
rm -rf OpenBLAS