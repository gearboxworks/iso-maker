#!/bin/bash

echo "Building..."
cp /build/genapkovl-*.sh /build/mkimg.*.sh /build/aports/scripts

cd /build/aports/scripts
./mkimage.sh --tag 1.0 \
	--outdir /iso \
	--arch x86_64 \
	--repository https://mirror.aarnet.edu.au/pub/alpine/v3.8/main \
	--extra-repository https://mirror.aarnet.edu.au/pub/alpine/v3.8/community \
	--profile gearbox_small >& /iso/output.log

echo "Completed."

