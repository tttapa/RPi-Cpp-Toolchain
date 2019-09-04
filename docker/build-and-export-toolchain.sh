#!/usr/bin/env bash
cd "$(dirname "$0")"

set -ex

docker-compose up --no-start --build build
docker cp eagle-raspberry:/home/develop/x-tools.tar ..
docker cp eagle-raspberry:/home/develop/RPi3-staging.tar ..
docker cp eagle-raspberry:/home/develop/RPi3-sysroot.tar ..