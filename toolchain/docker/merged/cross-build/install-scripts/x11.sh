#!/usr/bin/env bash

set -ex

# Download
git clone --single-branch --branch util-macros-1.19.1 --depth 1 \
    https://github.com/freedesktop/xorg-macros.git
git clone --single-branch --branch xcb-proto-1.14 --depth 1 \
    https://gitlab.freedesktop.org/xorg/proto/xcbproto.git
git clone --single-branch --branch xorgproto-2019.2 --depth 1 \
    https://github.com/freedesktop/xorg-xorgproto.git
git clone --single-branch --branch libXau-1.0.9 --depth 1 \
    https://gitlab.freedesktop.org/xorg/lib/libxau.git
git clone --single-branch --branch libxcb-1.14 --depth 1 \
    https://gitlab.freedesktop.org/xorg/lib/libxcb.git
git clone --single-branch --branch xtrans-1.4.0 --depth 1 \
    https://gitlab.freedesktop.org/xorg/lib/libxtrans.git
git clone --single-branch --branch libX11-1.6.9 --depth 1 \
    https://gitlab.freedesktop.org/xorg/lib/libx11.git
git clone --single-branch --branch libXrender-0.9.10 --depth 1 \
    https://gitlab.freedesktop.org/xorg/lib/libXrender.git
git clone --single-branch --branch libXfixes-5.0.3 --depth 1 \
    https://gitlab.freedesktop.org/xorg/lib/libXfixes.git
git clone --single-branch --branch libXcursor-1.2.0 --depth 1 \
    https://gitlab.freedesktop.org/xorg/lib/libXcursor.git


# Configure
. cross-pkg-config
export ACLOCAL_PATH=${RPI_SYSROOT}/usr/local/share/aclocal

pushd xorg-macros

autoreconf --install
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd xcbproto

autoreconf --install
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd xorg-xorgproto

autoreconf --install
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd libxau

autoreconf --install
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd libxcb

autoreconf --install
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd libxtrans

autoreconf --install
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd libx11

patch --forward configure.ac ../libx11-1.6.9.configure.ac.patch

autoreconf --install
./configure --help
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}" \
    --disable-specs \
    --enable-unix-transport \
    --enable-tcp-transport \
    --enable-ipv6 \
    --enable-local-transport \
    --disable-malloc0returnsnull
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd libXrender

autoreconf --install
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}" \
    --disable-malloc0returnsnull
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd libXfixes

autoreconf --install
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd libXcursor

autoreconf --install
./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd

# Cleanup
rm -rf xorg-macros
rm -rf xcbproto
rm -rf xorg-xorgproto
rm -rf libxau
rm -rf libxcb
rm -rf libxtrans
rm -rf libx11
rm -rf libXrender
rm -rf libXfixes
rm -rf libXcursor
