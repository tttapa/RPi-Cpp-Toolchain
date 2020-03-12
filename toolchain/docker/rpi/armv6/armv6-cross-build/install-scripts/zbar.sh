#!/usr/bin/env bash

set -ex

# Download
URL="http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xjf "${DOWNLOADS}/zbar-0.10.tar.bz2"
pushd zbar-0.10

# Disable -Werror (we're using a newer autoconf version)
sed -i 's/-Werror //g' configure.ac

# Original autoconf doesn't know aarch64, so run again with newer autoconf
autoreconf --install --force

# Configure
. cross-pkg-config
./configure \
    --disable-video --without-imagemagick --without-gtk --without-python \
    --without-qt --without-jpeg \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local" \
    CFLAGS="--sysroot=${RPI_SYSROOT} -O3" \
    LDFLAGS="--sysroot=${RPI_SYSROOT}" \
    CXXFLAGS="--sysroot=${RPI_SYSROOT} -O3"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf zbar-0.10