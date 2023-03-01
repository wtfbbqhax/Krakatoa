ARG ALPINE_VERSION
ARG ARCH

FROM $ARCH/alpine:$ALPINE_VERSION as alpine_package_builder
RUN apk update
RUN apk add abuild atools

RUN echo "@local /home/build/aports/packages" >> /etc/apk/repositories
COPY home/build/abuild/build.rsa.pub /etc/apk/keys
RUN adduser build build -D -s /bin/sh -h "/home/build"
RUN addgroup build abuild

RUN apk add sudo
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheel
RUN addgroup build wheel

COPY home/build/ /home/build
COPY packages/ /home/build/packages
RUN chown build:build -R /home/build

USER build
WORKDIR /home/build

ENV PACKAGE_DIR=/home/build/packages
RUN APKBUILD="$PACKAGE_DIR/jemalloc/APKBUILD" abuild -r
RUN APKBUILD="$PACKAGE_DIR/hyperscan/APKBUILD" abuild -r
RUN APKBUILD="$PACKAGE_DIR/hwloc/APKBUILD" abuild -r
RUN APKBUILD="$PACKAGE_DIR/libdaq/APKBUILD" abuild -r
RUN APKBUILD="$PACKAGE_DIR/snort3/APKBUILD" abuild -r
RUN APKBUILD="$PACKAGE_DIR/snort3-extra/APKBUILD" abuild -r

# cleanup
RUN unset PACKAGE_DIR
