#!/bin/bash

if [ ! -d /tmp/rootfs ]
then
	echo "Creating directory ..."
	mkdir -p /tmp/rootfs
fi

if [ -f /build/rootfs.changes.tar.gz ]
then
	echo "Extracting rootfs to /tmp/rootfs ..."
	tar zxf /build/rootfs.changes.tar.gz -C /tmp/rootfs/
fi
