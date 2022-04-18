#!/usr/bin/env bash

set -ex

# Download
version=4.3
URL="https://ftpmirror.gnu.org/gnu/make/make-$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/make-$version.tar.gz"

# Configure
. cross-pkg-config
pushd make-$version
./configure \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local" \
    CFLAGS="--sysroot=${RPI_SYSROOT} -O3" \
    CXXFLAGS="--sysroot=${RPI_SYSROOT} -O3"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf make-$version