#!/usr/bin/env bash

set -ex

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 arm|aarch64"
    exit 0
fi

case "$1" in
    arm)     target=arm-linux-gnueabihf ;;
    aarch64) target=aarch64-linux-gnu ;;
    *) echo "Unknown architecture. Choose either 'arm' or 'aarch64'"; exit 1 ;;
esac

version=9.1

cd /tmp
if [ ! -e gdb-$version.tar.xz ]; then
    wget https://ftp.gnu.org/gnu/gdb/gdb-$version.tar.xz
fi
rm -rf gdb-$version
tar xf gdb-$version.tar.xz
mkdir -p gdb-$version/build
cd gdb-$version/build

# Get the Python executable and library directory
[ -z "${PYTHON}" ] && export PYTHON=$(which python3)
PYTHON_LIBDIR=$("${PYTHON}" -c \
    "import sysconfig; print(sysconfig.get_config_var('LIBDIR'))")

../configure \
    --prefix=$HOME/.local \
    --target=$target \
    --with-python="${PYTHON}" \
    LDFLAGS="-L${PYTHON_LIBDIR}"

make -j$(nproc)
make -C gdb install
