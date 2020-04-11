#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

function print_usage {
    echo
    echo "Usage"
    echo "    $0 <board> [--push] [--pull] [--build-toolchain] [--export] [--export-toolchain]"
    echo
    echo "Boards"
    echo "    rpi"
    echo "        Raspberry Pi 1 and Zero, without development tools"
    echo
    echo "    rpi-dev"
    echo "        Raspberry Pi 1 and Zero, with development tools"
    echo
    echo "    rpi3-armv8"
    echo "        Raspberry Pi 3, 32-bit, without development tools"
    echo 
    echo "    rpi3-armv8-dev"
    echo "        Raspberry Pi 3, 32-bit, with development tools"
    echo
    echo "    rpi3-aarch64"
    echo "        Raspberry Pi 3, 64-bit, without development tools"
    echo
    echo "    rpi3-aarch64-dev"
    echo "        Raspberry Pi 3, 64-bit, with development tools"
    echo
    echo "Options"
    echo "    --push"
    echo "        After building, push the resulting image to Docker Hub"
    echo
    echo "    --pull"
    echo "        Don't build the image locally, pull everything from Docker Hub"
    echo
    echo "    --build-toolchain"
    echo "        Build the toolchains locally instead of pulling them from Docker Hub"
    echo
    echo "    --export"
    echo "        Export the toolchain, sysroot and staging area to your computer"
    echo
    echo "    --export-toolchain"
    echo "        Export only the toolchain to your computer"
    echo
}

# Check the number of arguments
if [ "$#" -lt 1 ]; then
    echo
    echo "Build or pull the Raspberry Pi GCC toolchain and cross-compiled libraries."
    print_usage
    exit 0
fi

# Check the board name
name="$1"
case "$name" in
rpi)
    target=armv6-rpi-linux-gnueabihf
    arch=armv6
    board=rpi
    dev=nodev
    ;;
rpi-dev)
    target=armv6-rpi-linux-gnueabihf
    arch=armv6
    board=rpi
    dev=dev
    ;;
rpi3-armv8)
    target=armv8-rpi3-linux-gnueabihf
    arch=armv8
    board=rpi3
    dev=nodev
    ;;
rpi3-armv8-dev)
    target=armv8-rpi3-linux-gnueabihf
    arch=armv8
    board=rpi3
    dev=dev
    ;;
rpi3-aarch64)
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    board=rpi3
    dev=nodev
    ;;
rpi3-aarch64-dev)
    target=aarch64-rpi3-linux-gnu
    arch=aarch64
    board=rpi3
    dev=dev
    ;;
*) echo; echo "Unknown board option '$1'"; print_usage; exit 1 ;;
esac

# Parse the other options
shift

build_toolchain=false
build=true
push=false
export=false
export_toolchain=false
docker_build_cpuset=

while (( "$#" )); do
    case "$1" in
        --push)             push=true                          ;;
        --pull)             build_toolchain=false; build=false ;;
        --build-toolchain)  build_toolchain=true               ;;
        --export)           export=true              ;;
        --export-toolchain) export_toolchain=true    ;;
        --cpuset-cpus=*)    docker_build_cpuset="$1" ;;
        *) echo; echo "Unknown option '$1'"; print_usage; exit 1 ;;
    esac
    shift
done

# Add -dev to tag if development build was selected
case "$dev" in
nodev)
    docker_target=build
    tag=$target
    ;;
dev)
    docker_target=developer-build
    tag=$target-dev
    ;;
esac

# Build or pull the Docker image with the cross-compilation toolchain
image=tttapa/rpi-cross-toolchain:$target
if [ $build_toolchain = true ]; then
    pushd docker/merged/cross-toolchain
    echo "Building Docker image $image"
    docker build \
        --tag $image \
        --build-arg HOST_TRIPLE=$target \
        ${docker_build_cpuset} .
    popd
    # Push the Docker image 
    if [ $push = true ]; then
        echo "Pushing Docker image $image"
        docker push $image
    fi
else
    echo "Pulling Docker image $image"
    [ ! -z $(docker images -q $image) ] || docker pull $image
fi

# Build or pull the Docker image with the cross-native toolchain
image=tttapa/rpi-cross-native-toolchain:$target
if [ $build_toolchain = true ] && [ $dev = dev ]; then
    pushd docker/merged/cross-native-toolchain
    echo "Building Docker image $image"
    docker build \
        --tag $image \
        --build-arg HOST_TRIPLE=$target \
        ${docker_build_cpuset} .
    popd
    # Push the Docker image 
    if [ $push = true ]; then
        echo "Pushing Docker image $image"
        docker push $image
    fi
elif [ $dev = dev ]; then
    echo "Pulling Docker image $image"
    [ ! -z $(docker images -q $image) ] || docker pull $image
fi

# Build or pull the Docker image with cross-compiled libraries
image=tttapa/rpi-cross:$tag
if [ $build = true ]; then
    pushd docker/merged
    echo "Building Docker image $image"
    . env/$target.env
    build_args=$(./env/env2arg.py env/$target.env)
    pushd cross-build
    docker build \
        --tag $image \
        ${build_args} \
        --target $docker_target \
        ${docker_build_cpuset} .
    popd
    popd
    # Push the Docker image 
    if [ $push = true ]; then
        echo "Pushing Docker image $image"
        docker push $image
    fi
else
    echo "Pulling Docker image $image"
    [ ! -z $(docker images -q $image) ] || docker pull $image
fi

# Export the toolchain etc. from the Docker image to the computer
if [ $export = true ]; then
    . ./scripts/export.sh
    export_all $image $target $target
fi

if [ $export_toolchain = true ]; then
    . ./scripts/export_toolchain.sh
    export_toolchain $image $target $target
fi
