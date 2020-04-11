#!/usr/bin/env bash

read -p "Are you sure you want to delete all toolchains, sysroots and staging areas
from this folder? [y/N] " yn
case $yn in
    [Yy]* ) ;;
    * ) echo "Abort."; exit;;
esac

set -ex

cd "$(dirname "$0")"

if ls x-tools 1> /dev/null 2>&1; then
    chmod -R u+w x-tools
    rm -rf x-tools
fi

if ls sysroot-* 1> /dev/null 2>&1; then
    find -type l -name 'sysroot-*' -delete
fi
if ls sysroot-* 1> /dev/null 2>&1; then
    chmod -R u+w sysroot-*
    rm -rf sysroot-*
fi

rm -f *.tar
