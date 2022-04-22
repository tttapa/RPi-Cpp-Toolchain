#!/usr/bin/env bash

# https://gist.github.com/benfogle/85e9d35e507a8b2d8d9dc2175a703c22

####################
# Script to build numpy and scipy wheels for ARM.

set -ex

GFORTRAN=${HOST_TRIPLE}-gfortran

BUILD_PYTHON=`which python3.10`
HOST_PYTHON="${RPI_SYSROOT}/usr/local/bin/python3.10"
SYSROOT="${RPI_SYSROOT}"

scipy_version=1.8.0
SCIPY_URL=https://files.pythonhosted.org/packages/b4/a2/4faa34bf0cdbefd5c706625f1234987795f368eb4e97bde9d6f46860843e/scipy-1.8.0.tar.gz


################################################################
# Set up crossenv
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

FC=$GFORTRAN F90=$GFORTRAN F77=$GFORTRAN python setup.py bdist_wheel
pip install $(ls ./dist/scipy*.whl)
cd ..

# Cleanup
rm -rf scipy-*.*.*
