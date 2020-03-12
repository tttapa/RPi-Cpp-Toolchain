#!/usr/bin/env bash

set -ex

cd "$(dirname "$0")"

if ls x-tools 1> /dev/null 2>&1; then
    chmod -R u+w x-tools && rm -rf x-tools
fi

if ls sysroot-* 1> /dev/null 2>&1; then
    chmod -R u+w sysroot-* && rm -rf sysroot-*
fi

rm -f *.tar
