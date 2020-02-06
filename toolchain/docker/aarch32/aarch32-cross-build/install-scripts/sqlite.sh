#!/usr/bin/env bash

set -ex

# Download
URL="https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/sqlite-autoconf-3290000.tar.gz"
pushd sqlite-autoconf-3290000

# Configure
. cross-pkg-config
./configure \
        --prefix="/usr/local" \
        --host="${HOST_TRIPLE}" \
        CFLAGS="--sysroot=${RPI3_SYSROOT}"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI3_SYSROOT}"
make install DESTDIR="${RPI3_STAGING}"

# Cleanup
popd
rm -rf sqlite-autoconf-3290000