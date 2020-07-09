#!/usr/bin/env bash

# https://gist.github.com/benfogle/85e9d35e507a8b2d8d9dc2175a703c22

####################
# Script to build numpy and scipy wheels for ARM.

set -ex

WORKING=$PWD
GFORTRAN=${HOST_TRIPLE}-gfortran

BUILD_PYTHON=`which python3.8`
HOST_PYTHON="${RPI_SYSROOT}/usr/local/bin/python3.8"
SYSROOT="${RPI_SYSROOT}"

numpy_version=1.19.0
scipy_version=1.5.1
NUMPY_URL=https://files.pythonhosted.org/packages/f1/2c/717bdd12404c73ec0c8c734c81a0bad7048866bc36a88a1b69fd52b01c07/numpy-1.19.0.zip
SCIPY_URL=https://files.pythonhosted.org/packages/8a/6c/7777c60626cf620ce24d6349af69f3d2a4f298729d688cc4cd9528ae3c61/scipy-1.5.1.tar.gz


################################################################
# Set up crossenv
$BUILD_PYTHON -m crossenv $HOST_PYTHON crossenv
. crossenv/bin/activate
# Set the Linux version of the crossenv (needed by NumPy)
cat > /tmp/set_release.py << EOF
from configparser import ConfigParser
config = ConfigParser()
filename = "$HOME/crossenv/crossenv.cfg"
config.read(filename)
config['uname']['release'] = '4.15'
with open(filename, 'w') as configfile:
    config.write(configfile)
EOF
python3.8 /tmp/set_release.py

python3 -c "import os; print(os.uname())"

BUILD_SITE=$PWD/crossenv/build/lib/python3.8/site-packages
CROSS_SITE=$PWD/crossenv/cross/lib/python3.8/site-packages

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
F90=$GFORTRAN cross-python setup.py bdist_wheel
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

#################################################################
# host-scipy
wget $SCIPY_URL
tar xf scipy-*.tar.gz && rm scipy-*.tar.gz
cd scipy-*.*.*
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

# Cleanup
rm -rf numpy-*.*.*
rm -rf scipy-*.*.*
