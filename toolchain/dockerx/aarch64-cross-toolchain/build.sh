#!/usr/bin/env bash

set -e
docker build . -t aarch64-cross-toolchain
