FROM raspbian-buster
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN mv /usr/local/man /usr/local/man-tmp
COPY --from=aarch64-installed /home/develop/RPi3-staging /
RUN cp -ar /usr/local/man/* /usr/local/man-tmp && \
    ls /usr/local/man && \
    rm -rf /usr/local/man && \
    mv /usr/local/man-tmp /usr/local/man 
RUN ldconfig

ENTRYPOINT [ "bash" ]