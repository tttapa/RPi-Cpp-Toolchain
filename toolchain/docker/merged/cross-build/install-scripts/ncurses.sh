#!/usr/bin/env bash

set -ex

# Download
version=6.3
URL="https://ftp.gnu.org/gnu/ncurses/ncurses-$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/ncurses-$version.tar.gz"
pushd ncurses-$version

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
    --with-pkg-config-libdir="/usr/local/lib/pkgconfig" \
    --enable-pc-files \
    --with-build-cc="gcc" \
    --host="${HOST_TRIPLE}" \
    CFLAGS="--sysroot=${RPI_SYSROOT} -O3"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}" \
    INSTALL="install --strip-program=${HOST_TRIPLE}-strip"
make install DESTDIR="${RPI_STAGING}" \
    INSTALL="install --strip-program=${HOST_TRIPLE}-strip"

# Cleanup
popd
rm -rf ncurses-$version