# iso-maker


# Create Docker container.
# docker build --rm -t pressboxx/iso-maker
docker build --rm -t pressboxx/alpine-iso

# Create ISO image.
# docker run --rm -v \`pwd\`/iso/:/iso/ -t -i --privileged pressboxx/iso-maker /bin/bash
docker run --rm -v \`pwd\`/iso/:/iso/ -v `pwd`/build/:/build/ -t -i --privileged pressboxx/alpine-iso /bin/bash

mkdir -p /tmp/rootfs/
tar zxf /build/rootfs.changes.tar.gz -C /tmp/rootfs/
cd /tmp/rootfs/
pacman -Syy rsync
rsync -HvaxP mick@macpro:~/go/src/GearboxAPI /tmp/rootfs/root/go/src


