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
cat /build/apks-gearbox-tiny.txt > "$rootfs/etc/apk/world"

# 3. Clone current tree and bake it in as a fallback.
#FALLBACK="$rootfs/var/lib/cache/fallback"
#git clone https://github.com/gearboxworks/box-scripts "${FALLBACK}/opt/gearbox"
#rm -f "${FALLBACK}/opt/gearbox/.cloned"
# 3. Remove packages.
apk del wireless-tools wpa_supplicant wpa_supplicant-openrc ppp-atm ppp-chat ppp-daemon ppp-l2tp ppp-minconn ppp-passprompt ppp-passwordfd ppp-pppoe ppp-radius ppp-winbind

# 4. tar it back up again for the ISO.
tar -c -C "$rootfs" . | gzip -9n > $HOSTNAME.apkovl.tar.gz

