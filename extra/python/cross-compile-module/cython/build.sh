#!/usr/bin/env bash

# This script builds the right Docker image from the Dockerfile in the docker
# folder, starts a container from that image, and runs the build-docker.sh 
# script that builds the Python module inside of that container.
# It'll produce a Python WHL package that you can install using `pip install`,
# it'll be located in the `dist` folder.

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

# Choose the right target
if [ $# -lt 1 ]; then
    export HOST_TRIPLET=aarch64-rpi3-linux-gnu
    # export HOST_TRIPLET=armv8-rpi3-linux-gnueabihf
    # export HOST_TRIPLET=armv6-rpi-linux-gnueabihf
    echo "Using default target platform ${HOST_TRIPLET}"
else
    export HOST_TRIPLET="$1"
fi

# Build the Docker image to use for building the module later
pushd docker
docker build --build-arg HOST_TRIPLET . # build with output
image=$(docker build --build-arg HOST_TRIPLET -q .) # get the image hash
popd

# Make sure the Docker user has permissions to write to the shared volume.
mkdir -p dist
chmod a+w dist
chmod a+w .

# Run the build-docker.sh script inside of this new Docker container
docker run \
    --rm \
    -it \
    -v "$PWD:/tmp/workdir" \
    -w "/tmp/workdir" \
    $image \
    "bash" "build-docker.sh"

# --rm automatically deletes the container when the command finishes
# -it runs the script in an interactive terminal
# -v mounts the current directory in the container so you can access the 
#     necessary files
# -w sets the working directory inside of the container
# $image specifies the image used to create the container from, it's the image
#     that was built a couple of lines earlier
# bash build-docker.sh is the command to execute in the container