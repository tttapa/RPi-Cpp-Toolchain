# Toolchain

- [Building the Cross-Compilation Toolchain](https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development/Building-The-Toolchain.html)
- [Cross-Compiling the Dependencies](https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development/Dependencies.html)

## Deleting the toolchain

The toolchain is read-only, so you can't simply delete it using `rm` or using
a file manager.  
The `clean.sh` script will delete the toolchain, the sysroot and the staging 
area for all architectures and configurations.  
It doesn't delete anything from the Docker containers, so you can just export it
again later, without building everything from scratch.

```sh
./clean.sh
```