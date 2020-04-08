#!/usr/bin/env bash

set -ex

# Download
URL="ftp://ftp.gnu.org/gnu/gdbm/gdbm-1.18.1.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/gdbm-1.18.1.tar.gz"
pushd gdbm-1.18.1

# Configure
. cross-pkg-config
./configure \
    --prefix="/usr/local" \
    --host="${HOST_TRIPLE}" \
    CPPFLAGS="--sysroot=${RPI_SYSROOT} \
            -I${RPI_SYSROOT}/usr/local/include" \
    CFLAGS="--sysroot=${RPI_SYSROOT} \
            -I${RPI_SYSROOT}/usr/local/include" \
    LDFLAGS="--sysroot=${RPI_SYSROOT} \
             -L${RPI_SYSROOT}/usr/local/lib"
# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf gdbm-1.18.1