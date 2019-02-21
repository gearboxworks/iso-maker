# iso-maker

## Create Docker container.
docker build --rm -t gearbox/iso-maker .

## Create ISO image.
docker run --rm -v `pwd`/build/:/build/ -t -i --privileged gearbox/iso-maker /bin/bash -l

mkdir -p /tmp/rootfs/ && tar zxf /build/rootfs.changes.tar.gz -C /tmp/rootfs/

rsync -HvaxP mick@macpro:~/go/src/GearboxAPI /tmp/rootfs/root/go/src
