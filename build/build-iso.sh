#!/bin/bash -l

# We need to use the '-l' option for bash to ensure we pull in all the profile setup.
# As part of the profile login, we execute /etc/profile.d/rootfs.sh, which untars the rootfs.changes.tar.gz file into /tmp/rootfs/

# set -x

echo "# Setting up rootfs..."
cd /build
cp /build/genapkovl-*.sh /build/mkimg.*.sh /build/aports/scripts
rm -rf /tmp/rootfs/opt/gearbox-fallback
git clone -b 0.5.0 https://github.com/gearboxworks/box-scripts /tmp/rootfs/opt/gearbox-fallback

if [ -d /tmp/rootfs ]
then
	echo "# Tarballing /tmp/rootfs to /build/rootfs.changes.tar.gz"
	tar zcf /build/rootfs.changes.tar.gz -C /tmp/rootfs .
fi

if [ ! -d /build/iso ]
then
	mkdir -p /build/iso
fi

echo "# Building..."
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

