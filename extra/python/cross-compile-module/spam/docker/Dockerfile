ARG HOST_TRIPLET
FROM tttapa/docker-arm-cross-build-scripts:${HOST_TRIPLET}

# You can download or install any dependencies you need here

# The advantage of installing them here instead of in the build-docker.sh
# script is that they will only be installed once, whereas the build-docker.sh
# script is executed in a fresh Docker container every time you want to build
# your module.

RUN . ${HOME}/crossenv/bin/activate && pip install -U setuptools wheel