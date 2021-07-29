#!/usr/bin/env bash

set -ex

# Download
version=3.4.2
URL="https://codeload.github.com/libffi/libffi/tar.gz/v$version"
pushd "${DOWNLOADS}"
wget -N "$URL" -O libffi-$version.tar.gz
popd

# Extract
tar xzf "${DOWNLOADS}/libffi-$version.tar.gz"
pushd libffi-$version

# Configure
. cross-pkg-config
./autogen.sh
./configure \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local" \
    CFLAGS="-O3" \
    CXXFLAGS="-O3" \
    --with-sysroot="${RPI_SYSROOT}"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf libffi-$version