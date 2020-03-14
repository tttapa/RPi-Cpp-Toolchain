echo
echo "Exporting toolchain ..."

case "$dev" in
nodev)
    image=$board-$arch-cross-toolchain ;;
dev)
    image=$board-$arch-cross-native-toolchain ;;
esac

echo "Creating archives in $image"
container=$(docker run -d $image \
    bash -c "tar cf x-tools.tar x-tools")
status=$(docker wait $container)
if [ $status -ne 0 ]; then
    echo "Error creating toolchain archive"
    exit 1
fi
echo "Copying toolchain from Docker container to host"
docker cp $container:/home/develop/x-tools.tar x-tools-$arch.tar
docker rm $container >/dev/null

echo "Extracting toolchain"
chmod -fR u+w x-tools/$target || :
rm -rf x-tools/$target
target_no_vendor=`echo $target | sed -E 's/(\w+)-\w+/\1/'`
chmod -fR u+w x-tools/HOST-$target_no_vendor || :
rm -rf x-tools/HOST-$target_no_vendor
tar xf x-tools-$arch.tar
rm x-tools-$arch.tar

chmod -fR u+w sysroot-$name || :
rm -rf sysroot-$name
ln -sf x-tools/armv6-rpi-linux-gnueabihf/$target/sysroot sysroot-$name