################################################################################
profile_gearbox_tiny() {
	profile_virt
	profile_abbrev="gearbox"
	title="Gearbox"
	desc="Optimized for Gearbox."
	arch="x86 x86_64"
	kernel_flavors="virt"
	kernel_cmdline="console=tty0 console=ttyS0,115200 ramdisk_size=400000"
	syslinux_serial="0 115200"
	modloop_sign="no"
	kernel_addons=""
	apks="$apks $(cat /build/apks-gearbox-tiny.txt)"
	root_apks="$apks"
	apkovl="genapkovl-gearbox-tiny.sh"
}
# mount -o remount,size=400M /

build_kernel() {
	local _flavor="$2" _modloopsign=
	shift 3
	# local _pkgs="$@"
	local _pkgs="$@ $rootfs_apks"
	set -x
	update-kernel -v \
		$_hostkeys \
		${_abuild_pubkey:+--apk-pubkey $_abuild_pubkey} \
		--media \
		--flavor "$_flavor" \
		--arch "$ARCH" \
		--package "$_pkgs" \
		--feature "$initfs_features" \
		--repositories-file "$APKROOT/etc/apk/repositories" \
		"$DESTDIR"
	set +x
}

build_apkso() {
	echo "Nope"
}

################################################################################
