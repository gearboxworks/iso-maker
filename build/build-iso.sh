#!/bin/bash -l

# We need to use the '-l' option for bash to ensure we pull in all the profile setup.
# As part of the profile login, we execute /etc/profile.d/rootfs.sh, which untars the rootfs.changes.tar.gz file into /tmp/rootfs/

# set -x

REPO="$1"


if [ ! -d /tmp/rootfs ]
then
	echo "# ERROR: We don't have a /tmp/rootfs. Something is wrong!"
	exit
fi

cd /build


echo "# Copy ISO build scripts."
cp /build/genapkovl-*.sh /build/mkimg.*.sh /build/aports/scripts


FALLBACK="$rootfs/var/lib/cache/fallback"
echo "# Pull ${FALLBACK}/opt/gearbox from GitHub."
rm -rf "${FALLBACK}/opt/gearbox"
git clone https://github.com/gearboxworks/box-scripts "${FALLBACK}/opt/gearbox"
rm -f "${FALLBACK}/opt/gearbox/.cloned"


if [ "${REPO}" != "" ]
then
	if [ -f "/build/${REPO}" ]
	then
		echo "# Override /tmp/rootfs/etc/apk/repositories file with ${REPO}:"
		cat "/build/${REPO}"
		echo ""
		cp "/build/${REPO}" /tmp/rootfs/etc/apk/repositories
		cp "/build/${REPO}" /etc/apk/repositories
	fi
fi


echo "# Save rootfs - Tarball /tmp/rootfs to /build/rootfs.changes.tar.gz"
tar zcf /build/rootfs.changes.tar.gz -C /tmp/rootfs .
if [ ! -s /build/rootfs.changes.tar.gz ]
then
	echo "# ERROR: /build/rootfs.changes.tar.gz is zero size. Something is wrong!"
	ls -l /build
	exit
fi


if [ ! -d /build/iso ]
then
	echo "# Creating ISO directory..."
	mkdir -p /build/iso
fi


echo "# Creating ISO..."
cd /build/aports/scripts
./mkimage.sh --tag 0.5.0 \
	--outdir /build/iso \
	--arch x86_64 \
	--repository https://mirror.aarnet.edu.au/pub/alpine/v3.8/main \
	--extra-repository https://mirror.aarnet.edu.au/pub/alpine/v3.8/community \
	--profile gearbox_small >& /build/iso/output.log

echo "# Completed."


echo ""
echo "# Tail build/iso/output.log"
tail /build/iso/output.log


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

