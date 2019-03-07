#!/bin/bash

TARBALL="/build/rootfs.changes.tar.gz"

if [ -d /tmp/rootfs ]
then
	if [ -f "${TARBALL}" ]
	then
		SAVEFILE="/build/rootfs.changes-$(date +%Y%m%d-%H%M%S).tar.gz"
		echo "# Moving ${TARBALL} to ${SAVEFILE}"
		mv "${TARBALL}" "${SAVEFILE}"
	fi

	echo "# Tarball /tmp/rootfs to ${TARBALL} ..."
	tar zcf /build/rootfs.changes.tar.gz -C /tmp/rootfs/ .
fi

