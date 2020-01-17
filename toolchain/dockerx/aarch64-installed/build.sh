#!/usr/bin/env bash

set -e

# docker buildx create --name testbuilder --driver docker
# docker buildx use testbuilder
docker buildx inspect --bootstrap
docker buildx build --platform linux/arm64 . --load -t aarch64-installed-x
# docker buildx rm testbuilder