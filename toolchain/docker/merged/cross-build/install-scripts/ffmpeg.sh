#!/usr/bin/env bash

set -ex

# Download
version=4.4.2
URL="https://ffmpeg.org/releases/ffmpeg-$version.tar.bz2"
pushd "${DOWNLOADS}"
wget -N "$URL"
popd

# Extract
tar xjf "$DOWNLOADS/ffmpeg-$version.tar.bz2"
pushd ffmpeg-$version

# Determine the architecture
case "${HOST_TRIPLE}" in
    aarch64* ) FFMPEG_ENABLE_NEON="--enable-neon" ;;
    armv8*   ) FFMPEG_ENABLE_NEON="--enable-neon" ;;
    armv7*   ) FFMPEG_ENABLE_NEON="--enable-neon" ;;
    armv6*   ) FFMPEG_ENABLE_NEON=""              ;;
    *        ) echo "Unknown architecture ${HOST_TRIPLE}" && exit 1 ;;
esac

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
    --enable-libvpx --enable-libx264 --enable-libxvid \
    --enable-omx --enable-omx-rpi --enable-mmal \
    ${FFMPEG_ENABLE_NEON} \
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
rm -rf ffmpeg-$version