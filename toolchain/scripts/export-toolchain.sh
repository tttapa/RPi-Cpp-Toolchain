function export_toolchain {

    image=$1
    name=$2
    target=$3
    
    echo
    echo "Exporting toolchain ..."
    echo "Creating archives"
    container=$(docker run -d $image \
        bash -c "tar cf x-tools.tar x-tools")
    status=$(docker wait $container)
    if [ $status -ne 0 ]; then
        echo "Error creating toolchain archives"
        exit 1
    fi
    echo "Copying toolchain from Docker container to host"
    docker cp $container:/home/develop/x-tools.tar x-tools-$name.tar
    docker rm $container >/dev/null

    echo "Extracting toolchain"
    chmod -fR u+w x-tools/$target || :
    rm -rf x-tools/$target
    tar xf x-tools-$name.tar
    rm x-tools-$name.tar

}