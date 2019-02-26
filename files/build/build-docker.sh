#!/bin/bash

# set -xe

APKS="$(cat /build/apks.txt)"

mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh
mv /build/rootfs.sh /etc/profile.d/
mv /build/repositories /etc/apk/

apk update
apk add --no-cache ${APKS}

rm -rf /var/cache/apk/*
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime

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

