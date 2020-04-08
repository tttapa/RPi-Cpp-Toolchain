#!/usr/bin/env bash

set -ex

# Download
git clone -b 'v0.3.7' --single-branch --depth 1 \
    https://github.com/xianyi/OpenBLAS


# Build
pushd OpenBLAS
make \
    CC="${HOST_TRIPLE}-gcc" \
    FC="${HOST_TRIPLE}-gfortran" \
    HOSTCC=gcc \
    TARGET=${HOST_CPU} \
    V=1

# Install
make install \
    DESTDIR="${RPI_SYSROOT}" \
    PREFIX="/usr/local" \
    FC="${HOST_TRIPLE}-gfortran"
make install \
    DESTDIR="${RPI_STAGING}" \
    PREFIX="/usr/local" \
    FC="${HOST_TRIPLE}-gfortran"

# Cleanup
popd
rm -rf OpenBLAS

################################################################################
#
# The FC variable for the install scripts is necessary for the makefiles to 
# detect the Fortran compiler, so that they will enable the LAPACK and LAPACKE
# libraries when installing.
#