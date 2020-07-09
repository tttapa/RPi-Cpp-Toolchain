#!/usr/bin/env bash

set -ex

# Download
URL="https://ftp.gnu.org/gnu/readline/readline-8.0.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/readline-8.0.tar.gz"
pushd readline-8.0

# Configure
. cross-pkg-config
./configure \
    --with-curses \
    --enable-shared \
    --prefix="/usr/local" \
    --host="${HOST_TRIPLE}" \
    CFLAGS="--sysroot=${RPI_SYSROOT} -O3" 

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf readline-8.0