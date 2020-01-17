#!/usr/bin/env bash

cd /tmp
export DOCKER_BUILDKIT=1
docker build --platform=local -o . git://github.com/docker/buildx
mkdir -p ~/.docker/cli-plugins
rm -rf ~/.docker/cli-plugins/docker-buildx
mv buildx ~/.docker/cli-plugins/docker-buildx
sudo systemctl restart docker