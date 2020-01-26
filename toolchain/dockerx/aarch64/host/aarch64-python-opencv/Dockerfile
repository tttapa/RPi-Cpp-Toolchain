FROM arm64v8/ubuntu:latest
ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Move aside the original /usr/local/man folder (it's a symlink)
RUN mv /usr/local/man /usr/local/man-tmp
# Copy the staging area from the cross compilation to the root of the filesystem
COPY --from=aarch64-python-opencv-cross /home/develop/RPi3-staging /
# Restore the man symlink
RUN cp -ar /usr/local/man/* /usr/local/man-tmp && \
    rm -rf /usr/local/man && \
    mv /usr/local/man-tmp /usr/local/man 
RUN ldconfig

ENTRYPOINT [ "bash" ]
