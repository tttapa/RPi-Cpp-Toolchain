#!/usr/bin/env bash

set -ex

# Download
version=3.8.2
URL="https://www.python.org/ftp/python/$version/Python-$version.tgz"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xzf "${DOWNLOADS}/Python-$version.tgz"
pushd Python-$version

# Configure
export PKG_CONFIG_LIBDIR=$HOME/.local/lib:/usr/lib
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:/usr/lib/pkgconfig
./configure \
    --prefix="$HOME/.local" \
    CFLAGS="-I$HOME/.local/lib/libffi-3.2.1/include \
            -I$HOME/.local/include" \
    CPPFLAGS="-I$HOME/.local/lib/libffi-3.2.1/include \
              -I$HOME/.local/include" \
    CXXFLAGS="-I$HOME/.local/lib/libffi-3.2.1/include \
              -I$HOME/.local/include" \
    LDFLAGS="-L$HOME/.local/lib -Wl,-rpath,\\\$\$ORIGIN/../lib"
cat config.log

# Build
make -j$(($(nproc) * 2))

# Install
make altinstall

# Cleanup
popd
rm -rf Python-$version