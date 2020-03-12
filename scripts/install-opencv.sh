#!/usr/bin/env bash

set -e

# Install dependencies
if sudo -v; then
    echo "-- Installing dependencies"
    sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev
else
    echo "[WARNING] Cannot install dependencies using the package manager"
    echo "          Please install them manually if necessary"
fi

# Install numpy
python3 -m pip install numpy

# Configuration
VERSION=4.2.0
PREFIX="$HOME/.local"

if [ ! -z "$VIRTUAL_ENV" ]; then
    echo "-- Installing in a Python Virtual Environment $VIRTUAL_ENV"
    PREFIX=$VIRTUAL_ENV
fi

# Download & extract OpenCV
cd /tmp
if [ ! -e opencv-$VERSION.tar.gz ]; then
    echo "-- Downloading OpenCV"
    wget -O opencv-$VERSION.tar.gz https://codeload.github.com/opencv/opencv/tar.gz/$VERSION
fi
echo "-- Extracting"
tar -xzf opencv-$VERSION.tar.gz

# Detect Python directories
py_include=`python3 -c "import sysconfig as sc; print(sc.get_path('include'))"`
py_library=`python3 -c "import sysconfig as sc; print(sc.get_config_var('LIBDIR') + '/' + sc.get_config_var('INSTSONAME'))"`
numpy_include=`python3 -c "import numpy.distutils as du; print(du.misc_util.get_numpy_include_dirs()[0])"`

# Build OpenCV x86
mkdir -p /tmp/opencv-x86-build && cd $_
cmake \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DWITH_JPEG=ON -DBUILD_JPEG=ON \
    -DWITH_PNG=ON -DBUILD_PNG=ON \
    -DWITH_TBB=ON -DBUILD_TBB=ON \
    -DWITH_FFMPEG=ON \
    -DWITH_V4L=ON -DWITH_LIBV4L=ON \
    -DOPENCV_GENERATE_PKGCONFIG=ON \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DPYTHON3_EXECUTABLE=`which python3` \
    -DBUILD_OPENCV_PYTHON2=OFF \
    -DBUILD_OPENCV_PYTHON3=ON \
    -DPYTHON_INCLUDE_DIR=$py_include \
    -DPYTHON_LIBRARY=$py_library \
    -DPYTHON3_NUMPY_INCLUDE_DIRS=$numpy_include \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_INSTALL_RPATH="$PREFIX/lib" \
    ../opencv-$VERSION

make -j$(($(nproc) * 2))
make install
