#!/usr/bin/env bash

set -ex

# Download
version=8-6-12
git clone --single-branch --branch core-$version --depth 1 \
    https://github.com/tcltk/tcl.git
git clone --single-branch --branch core-$version --depth 1 \
    https://github.com/tcltk/tk.git

# Determine the architecture
case "${HOST_TRIPLE}" in
    aarch64* ) TK_ENABLE_64_BIT="--enable-64bit" ;;
    armv?*   ) TK_ENABLE_64_BIT="" ;;
    *        ) echo "Unknown architecture ${HOST_TRIPLE}" && exit 1 ;;
esac

. cross-pkg-config
pushd tcl/unix

./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd
pushd tk/unix

x11_inc_rel=`pkg-config --variable=includedir x11`
x11_lib_rel=`pkg-config --variable=libdir x11`
x11_inc="${RPI_SYSROOT}${x11_inc_rel}"
x11_lib="${RPI_SYSROOT}${x11_lib_rel}"
export LDFLAGS="--sysroot=${RPI_SYSROOT} -Wl,-rpath-link,=${x11_lib_rel}"

./configure \
    --prefix="/usr/local" \
    --host=${HOST_TRIPLE} \
    --with-sysroot="${RPI_SYSROOT}" \
    ${TK_ENABLE_64_BIT} \
    --with-x \
    --x-includes="${x11_inc}" \
    --x-libraries="${x11_lib}"
make -j$(nproc)
make install DESTDIR=${RPI_SYSROOT}
make install DESTDIR=${RPI_STAGING}

popd