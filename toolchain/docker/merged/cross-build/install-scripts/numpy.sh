#!/usr/bin/env bash

# https://gist.github.com/benfogle/85e9d35e507a8b2d8d9dc2175a703c22

####################
# Script to build numpy and scipy wheels for ARM.

set -ex

WORKING=$PWD
GFORTRAN=${HOST_TRIPLE}-gfortran

BUILD_PYTHON=`which python3.10`
HOST_PYTHON="${RPI_SYSROOT}/usr/local/bin/python3.10"
SYSROOT="${RPI_SYSROOT}"

numpy_version=1.21.6
NUMPY_URL=https://files.pythonhosted.org/packages/45/b7/de7b8e67f2232c26af57c205aaad29fe17754f793404f59c8a730c7a191a/numpy-1.21.6.zip


################################################################
# Set up crossenv
. crossenv/bin/activate
python3 -c "import os; print(os.uname())"

BUILD_SITE=$PWD/crossenv/build/lib/python3.10/site-packages
CROSS_SITE=$PWD/crossenv/cross/lib/python3.10/site-packages

################################################################
# Host-numpy
# Install so we get the libnpymath.a in the right place.
export NPY_NUM_BUILD_JOBS=$(($(nproc) * 2))
export OPT='-DNDEBUG -O3'
export FOPT='-DNDEBUG -O3'

wget $NUMPY_URL
unzip -q numpy-*.zip && rm numpy-*.zip
cd numpy-*.*.*
cat > site.cfg <<EOF
[openblas]
libraries = openblas
library_dirs = $SYSROOT/usr/local/lib
include_dirs = $SYSROOT/usr/local/include
extra_link_args = -lgfortran
EOF
FC=$GFORTRAN F90=$GFORTRAN F77=$GFORTRAN cross-python setup.py bdist_wheel
pip install $(ls ./dist/numpy*.whl)
cd ..

################################################################
# Build-numpy. Need to patch _after_ install.
build-pip install numpy==$numpy_version
INI=$(find $BUILD_SITE -name 'npymath.ini')
LIBDIR=$(find $CROSS_SITE -path '*/numpy/core/lib')
INCDIR=$(find $CROSS_SITE -path '*/numpy/core/include')

cd $(dirname "$INI")
patch npymath.ini $WORKING/npymath.ini.patch
sed -i "s|@LIBDIR|${LIBDIR}|" npymath.ini
sed -i "s|@INCDIR|${INCDIR}|" npymath.ini
cd -

# Cleanup
rm -rf numpy-*.*.*
