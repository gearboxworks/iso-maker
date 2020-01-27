#!/bin/bash
# set -x


REPO="$1"

rootfs="/build/rootfs"
if [ ! -d ${rootfs} ]
then
	echo "# ERROR: We don't have a ${rootfs}. Something is wrong!"
	exit
fi

cd /build


################################################################################
echo "# Copy ISO build scripts."
cp /build/genapkovl-*.sh /build/mkimg.*.sh /build/aports/scripts


################################################################################
FALLBACK="$rootfs/var/lib/cache/fallback"
echo "# Pull ${FALLBACK}/opt/gearbox from GitHub."
rm -rf "${FALLBACK}/opt/gearbox"
git clone https://github.com/gearboxworks/box-scripts "${FALLBACK}/opt/gearbox"
rm -f "${FALLBACK}/opt/gearbox/.cloned"
rsync -HvaxP --delete "${FALLBACK}/opt/gearbox/etc/images" "${FALLBACK}/opt/gearbox/etc/repositories.json" "${FALLBACK}/etc/gearbox/"


################################################################################
if [ "${REPO}" != "" ]
then
	if [ -f "/build/${REPO}" ]
	then
		echo "# Override ${rootfs}/etc/apk/repositories file with ${REPO}:"
		cat "/build/${REPO}"
		echo ""
		cp "/build/${REPO}" ${rootfs}/etc/apk/repositories
		cp "/build/${REPO}" /etc/apk/repositories
	fi
fi


################################################################################
TARBALL="/build/rootfs.changes.tar.gz"
echo "# Tarball ${rootfs} to ${TARBALL} ..."
tar zcf /build/rootfs.changes.tar.gz -C ${rootfs} .
if [ ! -s /build/rootfs.changes.tar.gz ]
then
	echo "# ERROR: /build/rootfs.changes.tar.gz is zero size. Something is wrong!"
	ls -l /build
	exit
fi


################################################################################
if [ ! -d /build/iso ]
then
	echo "# Creating ISO directory..."
	mkdir -p /build/iso
fi


################################################################################
echo "# Creating ISO..."
cd /build/aports/scripts
./mkimage.sh --tag 0.5.1 \
	--outdir /build/iso \
	--arch x86_64 \
	--repository https://mirror.aarnet.edu.au/pub/alpine/v3.8/main \
	--extra-repository https://mirror.aarnet.edu.au/pub/alpine/v3.8/community \
	--profile gearbox_tiny >& /build/iso/output.log

echo "# Completed."


################################################################################
echo ""
echo "# Tail build/iso/output.log"
tail /build/iso/output.log


################################################################################
echo ""
echo "# Show ISOs"
MD5SUM="$(which md5sum)"
for iso in /build/iso/*.iso
do
	echo "# ${iso}"
	if [ "${MD5SUM}" != "" ]
	then
		if [ ! -f "${iso}.md5sum" ]
		then
			$MD5SUM "${iso}" > "${iso}.md5sum"
		fi

		ls -lh "${iso}" "${iso}.md5sum"
		cat "${iso}.md5sum"
	else
		ls -lh "${iso}"
	fi
done

