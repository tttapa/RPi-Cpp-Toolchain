#!/usr/bin/env bash

# This script downloads, builds and installs ZBar to ~/.local

set -ex

cd /tmp
wget http://downloads.sourceforge.net/project/zbar/zbar/0.10/zbar-0.10.tar.bz2
tar xjf zbar-0.10.tar.bz2
rm zbar-0.10.tar.bz2

mkdir -p zbar-0.10/build
cd zbar-0.10/build
../configure \
    --disable-video --without-imagemagick --without-gtk --without-python \
    --without-qt --without-jpeg \
    CFLAGS= \
    --prefix=$HOME/.local
make -j$(nproc)
make install
