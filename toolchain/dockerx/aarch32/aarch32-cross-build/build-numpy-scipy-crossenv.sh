#!/bin/bash

####################
# Script to build numpy and scipy wheels for ARM. Tested on a lightly patched
# buildroot.

set -ex

WORKING=$PWD
GFORTRAN=${HOST_TRIPLE}-gfortran

BUILD_PYTHON=`which python3.8`
HOST_PYTHON="${RPI3_SYSROOT}/usr/local/bin/python3.8"
SYSROOT="${RPI3_SYSROOT}"

NUMPY_URL=https://files.pythonhosted.org/packages/40/de/0ea5092b8bfd2e3aa6fdbb2e499a9f9adf810992884d414defc1573dca3f/numpy-1.18.1.zip
SCIPY_URL=https://files.pythonhosted.org/packages/04/ab/e2eb3e3f90b9363040a3d885ccc5c79fe20c5b8a3caa8fe3bf47ff653260/scipy-1.4.1.tar.gz


################################################################
# Set up crossenv
$BUILD_PYTHON -m crossenv $HOST_PYTHON venv
. venv/bin/activate

BUILD_SITE=$PWD/venv/build/lib/python3.8/site-packages
CROSS_SITE=$PWD/venv/cross/lib/python3.8/site-packages

################################################################
# Host-numpy
# Install so we get the libnpymath.a in the right place.
export NPY_NUM_BUILD_JOBS=$(($(nproc) * 2))
export OPT='-DNDEBUG -O3'
export FOPT='-DNDEBUG -O3'

wget $NUMPY_URL
unzip -q numpy-*.zip && rm numpy-*.zip
cd numpy-*
cat > site.cfg <<EOF
[openblas]
libraries = openblas
library_dirs = $SYSROOT/usr/local/lib
include_dirs = $SYSROOT/usr/local/include
extra_link_args = -lgfortran
EOF
F90=$GFORTRAN cross-python setup.py bdist_wheel
pip install $(ls ./dist/numpy*.whl)
cd ..

################################################################
# Build-numpy. Need to patch _after_ install.
build-pip install numpy==1.18.1
INI=$(find $BUILD_SITE -name 'npymath.ini')
LIBDIR=$(find $CROSS_SITE -path '*/numpy/core/lib')
INCDIR=$(find $CROSS_SITE -path '*/numpy/core/include')

cd $(dirname $INI)
git apply $WORKING/npymath.ini.patch
sed -i "s|@LIBDIR|${LIBDIR}|" npymath.ini
sed -i "s|@INCDIR|${INCDIR}|" npymath.ini
cd -

#################################################################
# host-scipy
wget $SCIPY_URL
wget https://github.com/scipy/scipy/commit/6a963029abc1ab79401fb3c1863c9d9f68020c4c.patch
tar xf scipy-*.tar.gz && rm scipy-*.tar.gz
cd scipy-*
git apply ../6a963029abc1ab79401fb3c1863c9d9f68020c4c.patch
cat > site.cfg <<EOF
[openblas]
libraries = openblas
library_dirs = $SYSROOT/usr/local/lib
include_dirs = $SYSROOT/usr/local/include
extra_link_args = -lgfortran
EOF

F90=$GFORTRAN python setup.py bdist_wheel
pip install $(ls ./dist/scipy*.whl)
cd ..