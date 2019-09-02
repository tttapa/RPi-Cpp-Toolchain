#!/usr/bin/env bash
cd "$(dirname "$0")"

set -x

if [ ! -f ../ubuntu-18.04.3-preinstalled-server-arm64+raspi3.img ]; then
    wget -P .. http://cdimage.ubuntu.com/releases/bionic/release/ubuntu-18.04.3-preinstalled-server-arm64+raspi3.img.xz
    xz --decompress ../ubuntu-18.04.3-preinstalled-server-arm64+raspi3.img.xz
fi
dev=`sudo losetup --show -Pf ../ubuntu-18.04.3-preinstalled-server-arm64+raspi3.img`
echo $dev
mkdir -p ubuntu-rootfs-mnt
sudo mount ${dev}p2 ubuntu-rootfs-mnt

sudo cp -rp ubuntu-rootfs-mnt ubuntu-rootfs

sudo umount ubuntu-rootfs-mnt
sudo losetup -d $dev