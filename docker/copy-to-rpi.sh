#!/usr/bin/env bash
cd "$(dirname "$0")"

set -ex

scp ../RPi3-sysroot.tar RPi3:/home/ubuntu
ssh RPi3 tar xf RPi3-sysroot.tar