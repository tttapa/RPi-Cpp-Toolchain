#!/usr/bin/env bash

set -ex

# Download
URL="https://github.com/openssl/openssl/archive/OpenSSL_1_1_1c.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/OpenSSL_1_1_1c.tar.gz"
pushd openssl-OpenSSL_1_1_1c

# Determine the architecture
case "${HOST_TRIPLE}" in
    aarch64* ) OPENSSL_ARCH="linux-aarch64" ;;
    armv?*   ) OPENSSL_ARCH="linux-armv4" ;;
    *        ) echo "Unknown architecture ${HOST_TRIPLE}" && exit 1 ;;
esac

# Configure
. cross-pkg-config
./Configure \
    --prefix="/usr/local" \
    --cross-compile-prefix="${HOST_TRIPLE}-" \
    CFLAGS="--sysroot=${RPI_SYSROOT}" \
    CPPFLAGS="--sysroot=${RPI_SYSROOT}" \
    LDFLAGS="--sysroot=${RPI_SYSROOT}" \
    "${OPENSSL_ARCH}"

# Build
make -j$(($(nproc) * 2))

# Install
make install_sw DESTDIR="${RPI_SYSROOT}"
make install_sw DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf openssl-OpenSSL_1_1_1c