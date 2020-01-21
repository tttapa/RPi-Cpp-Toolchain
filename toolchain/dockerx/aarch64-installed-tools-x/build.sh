#!/usr/bin/env bash

set -ex

# docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
# docker buildx rm testbuilder || true
# docker buildx create --name testbuilder --platform linux/arm64
# docker buildx use testbuilder
../../../scripts/install-docker-binfmt.sh
docker buildx inspect --bootstrap
docker buildx build --platform linux/arm64 . --load -t aarch64-installed-tools-x
# docker buildx rm testbuilder