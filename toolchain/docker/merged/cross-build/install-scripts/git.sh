#!/usr/bin/env bash

set -ex

# Download
version=2.29.3
URL="https://mirrors.edge.kernel.org/pub/software/scm/git/git-$version.0.tar.gz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/git-$version.0.tar.gz"

# Help Git find cURL
mkdir /tmp/curl-config
ln -s "${RPI_SYSROOT}/usr/local/bin/curl-config" /tmp/curl-config/
export PATH="/tmp/curl-config:${PATH}"

# Configure
pushd git-$version.0
. cross-pkg-config
make configure
patch configure ../git-$version.0.patch
./configure \
    --with-curl \
    --with-openssl \
    --host="${HOST_TRIPLE}" \
    --prefix="/usr/local" \
    CFLAGS="--sysroot ${RPI_SYSROOT} -O3 \
            -I${RPI_SYSROOT}/usr/local/include"

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf git-$version.0