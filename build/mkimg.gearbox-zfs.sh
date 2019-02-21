profile_gearbox_zfs() {
	profile_standard
	profile_abbrev="gearbox"
	title="Gearbox"
	desc="Optimized for Gearbox."
	arch="x86 x86_64"
	kernel_flavors="vanilla"
	kernel_cmdline="console=tty0 console=ttyS0,115200"
	syslinux_serial="0 115200"
	modloop_sign="no"
	kernel_addons="zfs spl"
	apks="$apks $(cat /build/apks-gearbox-zfs.txt)"
	root_apks="$apks"
	apkovl="genapkovl-gearbox-zfs.sh"
}

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

