# ARM Host Containers

The containers built by the Dockerfiles in this folder are ARM containers.  
The staging area of the cross compilation images is copied to the root of these
containers, so you can run the cross-compiled programs.

You need an ARM emulator on your computer in order to build and run them:
<https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/>

Also see [`/scripts/install-docker-buildx.sh`](/scripts/install-docker-buildx.sh).