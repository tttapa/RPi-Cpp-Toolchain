#!/usr/bin/env bash

set -e

mkdir -p /tmp/downloads
docker build . -t aarch64-installed