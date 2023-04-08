# Krakatoa
![Docker-Image CI](https://github.com/wtfbbqhax/Krakatoa/actions/workflows/docker-image.yml/badge.svg)

**FROM [Alpine Linux 3.17.3](https://www.alpinelinux.org/posts/Alpine-3.17.3-released.html)**

This repository serves as a reference for building a custom Alpine container images based on the Alpine Linux. We make use of the Alpine Packaging tools `abuild` and `apk` to build a package repository local to the image itself. The local package repo builds package and subpackage targets from the software listed below.

### Packaged Software 
Several dependencies to build a complete version of Snort 3 are not part officially supported by Alpine Linux or what does exist did not meet my expectations so they've been pulled directly. Additionally, the Snort3, Snort3 Extra and LibDAQ packages were solely produced for **Krakatoa**.

 * [hwloc 2.9.0](https://www-lb.open-mpi.org/software/hwloc/v2.9/)
 * [jemalloc 5.3.0](https://github.com/jemalloc/jemalloc/releases/tag/5.3.0/)
 * [Vectorscan 5.4.9](https://github.com/VectorCamp/vectorscan/releases/tag/vectorscan/5.4.9)
 * [LibDAQ 3.0.11](https://github.com/snort3/libdaq/releases/tag/v3.0.11)
 * [Snort3 3.1.59.0](https://github.com/snort3/snort3/releases/tag/3.1.59.0)
 * [Snort3 Extra 3.1.59.0](https://github.com/snort3/snort3_extra/releases/tag/3.1.59.0)
 * [AbcIP 2.4.1](https://github.com/crc181/abcip)[^1]
 * [Lightspd Manifest 0.1.0](https://github.com/wtfbbqhax/lightspd-manifest)

[^1]: AbcIP version 2.4.1 is not a real tagged build, our package builds the HEAD of master. -wtfbbqhax

## How to

1. Build Krakatoa image along with all packages

        make [build]


2. Run Krakatoa
    ```sh
    # From your host system, create a new Krakatoa container.
    docker run --rm -ti krakatoa
        
    # Now you are in the Krakatoa runtime, we will now install 
    # packages from the @local repository.

    # 1st Install Snort3
    sudo apk add snort3@local
        
    # 2nd Install DAQ modules
    # You wont be able to do much until you install some DAQ
    # modules; by default Snort3 will use pcap daq.
    sudo apk add libdaq-pcap-module@local

    # However I prefer to use the afpacket module.
    sudo apk add libdaq-afpacket-module@local

    # You can install any of the packaged modules using `apk`. 
    # All modules that can be built for Linux are available.
    # sudo apk add libdaq-fst-module@local libdaq-dump-module@local

    # 3rd, Test your new Snort installation
    sudo snort --daq-dir /usr/local/lib/daq \
        -c /usr/local/etc/snort/snort.lua \
        -k none \
        --daq afpacket -i eth0 
    ```

## Credits

 * Victor Roemer ([wtfbbqhax](https://www.github.com/wtfbbqhax))
