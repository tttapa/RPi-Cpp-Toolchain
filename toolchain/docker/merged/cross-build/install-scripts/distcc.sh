#!/usr/bin/env bash

set -ex

# Download
git clone --depth=1 --single-branch \
    https://github.com/distcc/distcc.git

# Configure
. cross-pkg-config
. crossenv/bin/activate
pushd distcc
./autogen.sh
./configure \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local" \
    CFLAGS="-O3 -Wimplicit-fallthrough=0 --sysroot ${RPI_SYSROOT}" \
    CXXFLAGS="-O3 -Wimplicit-fallthrough=0 --sysroot ${RPI_SYSROOT}"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf distcc

# Patch Python path
patch "${RPI_STAGING}/usr/local/bin/pump" "pump.patch"
