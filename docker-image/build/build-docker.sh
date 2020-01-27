#!/bin/bash

# set -xe

APKS="$(cat /build/apks.txt)"

cp /build/rootfs/etc/apk/repositories /etc/apk/

apk update
apk add --no-cache ${APKS}

rm -rf /var/cache/apk/*

rsync -HvaxP /build/rootfs/ /
mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh

addgroup gearbox
adduser -h /home/gearbox -D gearbox -G gearbox

# addgroup abuild
adduser -h /build -D build -G abuild
echo 'build ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers

addgroup root abuild
addgroup build abuild

abuild-keygen -i -a
ls /etc/apk/keys/

# git clone git://git.alpinelinux.org/aports

# cd /build/aports/scripts
echo "All setup."
echo "Now you can generate an ISO using:"
echo "docker run --rm -v \`pwd\`/build/:/build/ -t -i --privileged gearbox/iso-maker /bin/bash"

