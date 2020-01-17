#!/usr/bin/env bash

sudo apt install qemu-user-static
docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
sudo systemctl restart docker