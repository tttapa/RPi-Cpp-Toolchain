#!/usr/bin/env bash

set -ex

# Download
version=1_1_1n
URL="https://github.com/openssl/openssl/archive/OpenSSL_$version.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/OpenSSL_$version.tar.gz"
pushd openssl-OpenSSL_$version

# Determine the architecture
case "${HOST_TRIPLE}" in
    aarch64* ) OPENSSL_ARCH="linux-aarch64" ;;
    armv?*   ) OPENSSL_ARCH="linux-armv4" ;;
    *        ) echo "Unknown architecture ${HOST_TRIPLE}" && exit 1 ;;
esac

# Configure
. cross-pkg-config
CPPFLAGS="--sysroot=${RPI_SYSROOT} " \
LDFLAGS="--sysroot=${RPI_SYSROOT} " \
./Configure \
    --prefix="/usr/local" \
    --cross-compile-prefix="${HOST_TRIPLE}-" \
    --release \
    "${OPENSSL_ARCH}"
# Setting CFLAGS seems to mess up the configure script, so it doesn't pass the
# optimization options to the compiler

# Build
make -j$(($(nproc) * 2))

# Install
make install_sw DESTDIR="${RPI_SYSROOT}"
make install_sw DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf openssl-OpenSSL_$version
