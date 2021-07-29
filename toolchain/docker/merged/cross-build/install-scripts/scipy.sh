#!/usr/bin/env bash

# https://gist.github.com/benfogle/85e9d35e507a8b2d8d9dc2175a703c22

####################
# Script to build numpy and scipy wheels for ARM.

set -ex

GFORTRAN=${HOST_TRIPLE}-gfortran

BUILD_PYTHON=`which python3.9`
HOST_PYTHON="${RPI_SYSROOT}/usr/local/bin/python3.9"
SYSROOT="${RPI_SYSROOT}"

scipy_version=1.7.0
SCIPY_URL=https://files.pythonhosted.org/packages/bb/bb/944f559d554df6c9adf037aa9fc982a9706ee0e96c0d5beac701cb158900/scipy-1.7.0.tar.gz


################################################################
# Set up crossenv
$BUILD_PYTHON -m crossenv $HOST_PYTHON crossenv
. crossenv/bin/activate
python -c "import os; print(os.uname())"

#################################################################
# host-scipy
wget $SCIPY_URL
tar xf scipy-*.tar.gz && rm scipy-*.tar.gz
cd scipy-*.*.*
# This is
cat > site.cfg <<EOF
[openblas]
libraries = openblas
library_dirs = $SYSROOT/usr/local/lib
include_dirs = $SYSROOT/usr/local/include
extra_link_args = -lgfortran
EOF

export NPY_NUM_BUILD_JOBS=$(($(nproc) * 2))
export OPT='-DNDEBUG -O3'
export FOPT='-DNDEBUG -O3'

F90=$GFORTRAN python setup.py bdist_wheel
pip install $(ls ./dist/scipy*.whl)
cd ..

# Cleanup
rm -rf scipy-*.*.*
