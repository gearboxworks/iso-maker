#!/bin/bash

echo "Setting up rootfs..."
cd /build
cp /build/genapkovl-*.sh /build/mkimg.*.sh /build/aports/scripts
# git clone -b 1.0.0 https://github.com/gearboxworks/box-scripts /tmp/rootfs/opt/gearbox
# git clone -b 1.0.0 https://github.com/gearboxworks/box-scripts /tmp/rootfs/opt/gearbox-fallback
tar zcf /build/rootfs.changes.tar.gz -C /tmp/rootfs .

echo "Building..."
cd /build/aports/scripts
./mkimage.sh --tag 1.0 \
	--outdir /build/iso \
	--arch x86_64 \
	--repository https://mirror.aarnet.edu.au/pub/alpine/v3.8/main \
	--extra-repository https://mirror.aarnet.edu.au/pub/alpine/v3.8/community \
	--profile gearbox_small >& /build/iso/output.log

echo "Completed."

echo ""
echo ""
tail /build/iso/output.log

echo ""
echo ""
ls -lrth /build/iso/*.iso

