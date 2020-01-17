#!/usr/bin/env bash

set -e

# docker buildx rm mybuilder || true
# docker buildx create --name mybuilder --driver docker
# docker buildx use mybuilder
docker buildx inspect --bootstrap
docker buildx build --platform linux/arm64 . --load -t aarch64-toolchain-installed-x
# docker buildx rm mybuilder