#!/usr/bin/env bash

set -ex

BUILD_PYTHON=`which python3.10`
HOST_PYTHON="${RPI_SYSROOT}/usr/local/bin/python3.10"

URL=https://files.pythonhosted.org/packages/c6/e6/986a967dcca91d89e36f4d4a2f69a052030bce01a7cd48a6b7fba1a50189/pythran-0.9.12.post1.tar.gz

################################################################
# Set up crossenv
. crossenv/bin/activate
python3 -c "import os; print(os.uname())"

#################################################################
wget $URL
tar xf pythran-*.tar.gz && rm pythran-*.tar.gz
cd pythran-*.*.*
python setup.py bdist_wheel
pip install $(ls ./dist/pythran*.whl)
cd ..

# Cleanup
rm -rf pythran-*.*.*
