#!/usr/bin/env bash

set -ex

# docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
# docker buildx rm testbuilder || true
# docker buildx create --name testbuilder --driver docker-container
# docker buildx use testbuilder
# docker buildx inspect testbuilder --bootstrap
docker buildx build --platform linux/arm64 . --load -t aarch64-installed-tools-x
# docker buildx rm testbuilder