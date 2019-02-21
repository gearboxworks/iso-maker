#!/bin/bash

set -xe

APKS="
alpine-baselayout alpine-conf alpine-keys alpine-sdk apk-tools
bash build-base busybox diffutils
dosfstools
fakeroot
git go go-tools grub-efi
less libc-utils
make mtools
openssh-client
rsync
squashfs-tools sudo syslinux
tzdata
vim
xorriso
"

echo "http://dl-cdn.alpinelinux.org/alpine/v3.8/main
http://dl-cdn.alpinelinux.org/alpine/v3.8/community
http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
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

mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh

# git clone git://git.alpinelinux.org/aports

cd /build/aports/scripts
echo "All setup."
echo "Now you can type `build.sh`."

