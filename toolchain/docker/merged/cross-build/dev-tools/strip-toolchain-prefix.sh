#!/usr/bin/env bash

link_toolchain_bin () {
    newname=$(sed "s|.*$1-||" <<< "$2")
    echo $2
    echo $newname
    [ "$newname" == "ldd" ] || ln -s "$2" "$3/$newname"
}

find "$2" -name "$1-*" -type f | while read bin; \
    do link_toolchain_bin "$1" "$bin" "$3"; done