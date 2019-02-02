#!/bin/sh -e

echo "======= CONFIG $PWD =============="
echo "$*"
echo "================================="

HOSTNAME="$1"
if [ -z "$HOSTNAME" ]; then
	echo "usage: $0 hostname"
	exit 1
fi

cleanup() {
	rm -rf "$rootfs"
}

rootfs="$(mktemp -d)"
trap cleanup EXIT

# 1. Extract rootfs changes file so we can add some more changes.
tar zxf /build/rootfs.changes.tar.gz -C "$rootfs"

# 2. Add the changes here.
echo "${HOSTNAME}" > "$rootfs/etc/hostname"
cat /build/apks-gearbox-zfs.txt > "$rootfs/etc/apk/world"

# Clone current tree and bake it in as a fallback.
git clone https://github.com/wplib/box-scripts.git "$rootfs/opt/gearbox-fallback"
rm -f "$rootfs/opt/gearbox-fallback/.cloned"

# Then pull in a specific version for this release.
git clone -b 1.0.0 https://github.com/wplib/box-scripts "$rootfs/opt/gearbox"
rm -f "$rootfs/opt/gearbox/.cloned"

# 3. tar it back up again for the ISO.
tar -c -C "$rootfs" . | gzip -9n > $HOSTNAME.apkovl.tar.gz

