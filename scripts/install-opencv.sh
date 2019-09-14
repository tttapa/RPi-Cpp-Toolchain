#!/usr/bin/env bash

set -ex

# Install dependencies
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev \
                    libjpeg-dev libpng-dev libtiff-dev libjasper-dev \
                    libdc1394-22-dev

# Install numpy
python3 -m pip install --user numpy

# Download OpenCV
cd /tmp
if [ ! -e opencv-4.1.1.tar.gz ]; then
    wget -O opencv-4.1.1.tar.gz https://codeload.github.com/opencv/opencv/tar.gz/4.1.1
fi
tar -xzf opencv-4.1.1.tar.gz

# Build OpenCV x86
mkdir -p /tmp/opencv-x86-build && cd $_
py_include=`python3 -c "import sysconfig as sc; print(sc.get_path('include'))"`
py_library=`python3 -c "import sysconfig as sc; print(sc.get_config_var('LIBDIR') + '/' + sc.get_config_var('INSTSONAME'))"`
numpy_include=`python3 -c "import numpy.distutils as du; print(du.misc_util.get_numpy_include_dirs()[0])"`
cmake \
    -DWITH_V4L=ON -DWITH_LIBV4L=ON \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DPYTHON3_EXECUTABLE=`which python3` \
    -DPYTHON_INCLUDE_DIR=$py_include \
    -DPYTHON_LIBRARY=$py_library \
    -DPYTHON3_NUMPY_INCLUDE_DIRS=$numpy_include \
    -DCMAKE_INSTALL_PREFIX=$HOME/.local \
    ../opencv-4.1.1
make -j$(($(nproc) * 2))
make install

echo "$HOME/.local/lib" | sudo tee -a /etc/ld.so.conf
sudo ldconfig