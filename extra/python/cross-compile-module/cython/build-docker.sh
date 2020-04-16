#!/usr/bin/env bash

# Cross-compiles a Python module.

# This script should be run inside of the right Docker container. 
# Don't run this script directly, use the `build.sh` script.

set -e

# Cross-compiling a module with setup.py
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

source ~/crossenv/bin/activate # See https://github.com/benfogle/crossenv

# Build your package and export it as a wheel distribution
python setup.py bdist_wheel