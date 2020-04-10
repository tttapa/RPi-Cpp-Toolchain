#!/usr/bin/env bash

set -ex

# Download
URL="https://ffmpeg.org/releases/ffmpeg-4.2.tar.bz2"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xjf "$DOWNLOADS/ffmpeg-4.2.tar.bz2"
pushd ffmpeg-4.2

# Configure
. cross-pkg-config
./configure \
    --arch="${HOST_ARCH}" \
    --target-os="linux" \
    --prefix="/usr/local" \
    --sysroot="${RPI_SYSROOT}" \
    --enable-cross-compile \
    --cross-prefix="${HOST_TRIPLE}-" \
    --toolchain=hardened \
    --enable-gpl --enable-nonfree \
    --enable-avresample \
    --enable-libvpx --enable-libx264 --enable-libxvid \
    --enable-omx --enable-omx-rpi --enable-mmal --enable-neon \
    --enable-shared \
    --disable-static \
    --disable-doc \
    --extra-cflags="$(pkg-config --cflags mmal) \
                    -I${RPI_SYSROOT}/usr/local/include \
                    -I${RPI_SYSROOT}/opt/vc/include/IL" \
    --extra-ldflags="$(pkg-config --libs-only-L mmal) \
                     -Wl,-rpath-link,${RPI_SYSROOT}/opt/vc/lib \
                     -Wl,-rpath,/opt/vc/lib" \
 || cat ffbuild/config.log
    
# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf ffmpeg-4.2