echo
echo "Exporting toolchain ..."
echo "Creating archives"
container=$(docker run -d $image \
    bash -c "tar cf RPi3-staging.tar RPi3-staging & \
             tar cf RPi3-sysroot.tar RPi3-sysroot & \
             tar cf x-tools.tar x-tools & \
             wait")
status=$(docker wait $container)
if [ $status -ne 0 ]; then
    echo "Error creating toolchain archives"
    exit 1
fi
echo "Copying staging area from Docker container to host"
docker cp $container:/home/develop/RPi3-staging.tar RPi3-staging-$name.tar
echo "Copying sysroot from Docker container to host"
docker cp $container:/home/develop/RPi3-sysroot.tar RPi3-sysroot-$name.tar
echo "Copying toolchain from Docker container to host"
docker cp $container:/home/develop/x-tools.tar x-tools-$arch.tar
docker rm $container >/dev/null

echo "Extracting sysroot"
chmod -fR u+w RPi3-sysroot-$name || :
rm -rf RPi3-sysroot-$name
mkdir RPi3-sysroot-$name
tar xf RPi3-sysroot-$name.tar -C RPi3-sysroot-$name --strip-components 1
rm RPi3-sysroot-$name.tar

echo "Extracting toolchain"
chmod -fR u+w x-tools/$target || :
rm -rf x-tools/$target
tar xf x-tools-$arch.tar
rm x-tools-$arch.tar