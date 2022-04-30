#!/usr/bin/env bash

# Cross-compiles a Python module.

# This script should be run inside of the right Docker container. 
# Don't run this script directly, use the `build.sh` script.

set -e

# Configuring the cross-compilation
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cp ~/${HOST_TRIPLE}.cmake QPALM/toolchain.cmake

sed -e "s|@HOST_PYTHON_MACHINE@|$HOST_PYTHON_MACHINE|g" \
    -e "s|@RPI_SYSROOT@|$RPI_SYSROOT|g" \
    py-build-cmake.cross.toml.in \
>   QPALM/py-build-cmake.cross.toml

# Cross-compiling a module with py-build-cmkae
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Build your package and export it as a wheel distribution
python3.10 -m build --wheel QPALM

# Audit the wheel, include external libraries, and patch up tags
source ~/crossenv/bin/activate
python -m auditwheel repair QPALM/dist/*linux_$HOST_PYTHON_MACHINE.whl
