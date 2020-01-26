#!/usr/bin/env bash

set -e

image="$1"
executable="$2"

container=$(docker create --rm -it "$image" /tmp/$(basename "$executable"))
echo $container
docker cp "$executable" $container:/tmp/
docker start --attach --interactive $container