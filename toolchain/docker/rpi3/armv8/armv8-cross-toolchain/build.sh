#!/usr/bin/env bash

set -e
docker build . -t armv8-cross-toolchain
