#!/usr/bin/env bash

set -ex

# Download
URL="https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/Python-3.8.1.tgz"
pushd Python-3.8.1

# Configure
# Use the pkg-config folder inside of the RPi's root filesystem
export PKG_CONFIG_LIBDIR=$HOME/.local/lib
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig
./configure \
    --prefix="$HOME/.local" \
    CFLAGS="-I$HOME/.local/lib/libffi-3.2.1/include \
            -I$HOME/.local/include"
    CPPFLAGS="-I$HOME/.local/lib/libffi-3.2.1/include \
              -I$HOME/.local/include"
    CXXFLAGS="-I$HOME/.local/lib/libffi-3.2.1/include \
              -I$HOME/.local/include"
    LDFLAGS="-L$HOME/.local/lib"
cat config.log

# Build
make -j$(($(nproc) * 2))

# Install
make altinstall

# Cleanup
popd
rm -rf Python-3.8.1