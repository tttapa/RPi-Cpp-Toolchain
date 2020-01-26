#!/usr/bin/env bash

set -ex

# Download
URL="ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/ncurses-6.1.tar.gz"
pushd ncurses-6.1

# Configure
. cross-pkg-config
./configure \
    --enable-termcap \
    --enable-getcap \
    --without-normal \
    --with-shared --without-debug \
    --without-ada --enable-overwrite \
    --prefix="/usr/local" \
    --datadir="/usr/local/share" \
    --with-build-cc="gcc" \
    --host="${HOST_TRIPLE}" \
    CFLAGS="--sysroot=${RPI3_SYSROOT}"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI3_SYSROOT}" \
    INSTALL="install --strip-program=${HOST_TRIPLE}-strip"
make install DESTDIR="${RPI3_STAGING}" \
    INSTALL="install --strip-program=${HOST_TRIPLE}-strip"

# Cleanup
popd
rm -rf ncurses-6.1