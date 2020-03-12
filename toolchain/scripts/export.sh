echo
echo "Exporting toolchain ..."
echo "Creating archives"
container=$(docker run -d $image-cross \
    bash -c "tar cf RPi-staging.tar RPi-staging & \
             tar cf RPi-sysroot.tar RPi-sysroot & \
             tar cf x-tools.tar x-tools & \
             wait")
status=$(docker wait $container)
if [ $status -ne 0 ]; then
    echo "Error creating toolchain archives"
    exit 1
fi
echo "Copying staging area from Docker container to host"
docker cp $container:/home/develop/RPi-staging.tar staging-$name.tar
echo "Copying sysroot from Docker container to host"
docker cp $container:/home/develop/RPi-sysroot.tar sysroot-$name.tar
echo "Copying toolchain from Docker container to host"
docker cp $container:/home/develop/x-tools.tar x-tools-$arch.tar
docker rm $container >/dev/null

echo "Extracting sysroot"
chmod -fR u+w sysroot-$name || :
rm -rf sysroot-$name
mkdir sysroot-$name
tar xf sysroot-$name.tar -C sysroot-$name --strip-components 1
rm sysroot-$name.tar

echo "Extracting toolchain"
chmod -fR u+w x-tools/$target || :
rm -rf x-tools/$target
tar xf x-tools-$arch.tar
rm x-tools-$arch.tar