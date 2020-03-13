#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

docker build . -t armv8-cross-toolchain
