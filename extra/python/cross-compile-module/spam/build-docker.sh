#!/usr/bin/env bash

# Cross-compiles a Python module.

# This script should be run inside of the right Docker container. 
# Don't run this script directly, use the `build.sh` script.

# There are two main methods for building Python modules. 
#
# The recommended way is to use setuptools, which will invoke the compiler with 
# the right options for you.
# Crossenv is used to make sure you're building modules for the cross-compiled
# version of Python, not for the Python version on the build machine.
#
# If you really wanted to, you could also compile everything manually. If you
# choose to go this route (I wouldn't recommend it), you have to make sure that
# you are using the cross compiler, and that you are linking against the 
# cross-compiled version of Python, not the one on the build machine.
# To do this, prefix the compiler tools you're using with the host triplet, and
# use the Python configuration in the sysroot.

set -e

# Cross-compiling a module with setup.py
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

source ~/crossenv/bin/activate # See https://github.com/benfogle/crossenv

# Install the wheel package to build wheel packages
pip install wheel

# Build your package and export it as a wheel distribution
python setup.py bdist_wheel

# Manually compile C/C++ code that links to Python
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set -x

# Uses the python-config script in the RPi's sysroot, not the one on the 
# build machine
PY_CONFIG="${RPI_SYSROOT}/usr/local/bin/python3.10-config"
OPTS=$(${PY_CONFIG} --cflags --ldflags --embed)

# Use the cross-compiler
CC=${HOST_TRIPLE}-gcc

# Compile it
${CC} ${OPTS} -fPIC -shared "spammodule.c" -o "spam-manual-${HOST_TRIPLE}.so"