#!/usr/bin/env bash

set -ex

# Download
URL="https://codeload.github.com/opencv/opencv/tar.gz/4.2.0"
pushd "${DOWNLOADS}"
wget -N "$URL" -O opencv-4.2.0.tar.gz
popd

# Extract
tar xzf "${DOWNLOADS}/opencv-4.2.0.tar.gz"
mkdir opencv-4.2.0/build-arm

# Configure
. cross-pkg-config
. crossenv/bin/activate
pushd opencv-4.2.0/build-arm
NUMPY_INC=$(python3.8 -c "import numpy; print(numpy.get_include(),end='')")
cmake \
    -DCMAKE_TOOLCHAIN_FILE=../platforms/linux/arm.toolchain.cmake \
    -DGNU_MACHINE="${HOST_TRIPLE}" \
    -DCMAKE_SYSTEM_PROCESSOR="${HOST_ARCH}" \
    -DCMAKE_SYSROOT="${RPI_SYSROOT}" \
    -DENABLE_NEON=ON \
    -DOPENCV_ENABLE_NONFREE=ON \
    -DWITH_JPEG=ON -DBUILD_JPEG=ON \
    -DWITH_PNG=ON -DBUILD_PNG=ON \
    -DWITH_TBB=ON -DBUILD_TBB=ON \
    -DWITH_FFMPEG=ON \
    -DWITH_V4L=ON -DWITH_LIBV4L=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
    -DOPENCV_GENERATE_PKGCONFIG=ON \
    -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF \
    -DPYTHON3_INCLUDE_PATH="${RPI_SYSROOT}/usr/local/include/python3.8" \
    -DPYTHON3_LIBRARIES="${RPI_SYSROOT}/usr/local/lib/libpython3.8.so" \
    -DPYTHON3_NUMPY_INCLUDE_DIRS="$NUMPY_INC" \
    -DBUILD_OPENCV_PYTHON2=OFF \
    -DBUILD_OPENCV_PYTHON3=ON \
    -DBUILD_EXAMPLES=OFF \
    .. \
 || cat CMakeFiles/CMakeError.log
cat CMakeFiles/CMakeOutput.log

# Build
make -j$(($(nproc) * 2))

# Install
make install DESTDIR="${RPI_SYSROOT}"
make install DESTDIR="${RPI_STAGING}"

# Cleanup
popd
rm -rf opencv-4.2.0

# Patch the architecture name
# mv  ${RPI_SYSROOT}/usr/local/lib/python3.8/site-packages/cv2/python-3.8/cv2.cpython-38-x86_64-linux-gnu.so \
#     ${RPI_SYSROOT}/usr/local/lib/python3.8/site-packages/cv2/python-3.8/cv2.cpython-38-${HOST_ARCH}-linux-gnu.so && \
# mv  ${RPI_STAGING}/usr/local/lib/python3.8/site-packages/cv2/python-3.8/cv2.cpython-38-x86_64-linux-gnu.so \
#     ${RPI_STAGING}/usr/local/lib/python3.8/site-packages/cv2/python-3.8/cv2.cpython-38-${HOST_ARCH}-linux-gnu.so
