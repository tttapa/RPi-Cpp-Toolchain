#!/usr/bin/env bash

set -ex

# Download
git clone -b 'v0.3.7' --single-branch --depth 1 \
    https://github.com/xianyi/OpenBLAS

# Determine the architecture
case "${HOST_TRIPLE}" in
    aarch64-rpi4* ) OPENBLAS_HOST_CPU="CORTEXA72" ;;
    aarch64-rpi3* ) OPENBLAS_HOST_CPU="CORTEXA53" ;;
    armv8*        ) OPENBLAS_HOST_CPU="ARMV7" ;; # ARMV8 is 64-bit in OpenBLAS
    armv7*        ) OPENBLAS_HOST_CPU="ARMV7" ;;
    armv6*        ) OPENBLAS_HOST_CPU="ARMV6" ;;
    *             ) echo "Unknown architecture ${HOST_TRIPLE}" && exit 1 ;;
esac

# Build
pushd OpenBLAS
make \
    CC="${HOST_TRIPLE}-gcc" \
    FC="${HOST_TRIPLE}-gfortran" \
    HOSTCC=gcc \
    TARGET=${OPENBLAS_HOST_CPU} \
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