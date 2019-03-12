#!/bin/bash

create_container() {
	echo "# Create Docker container to build a Gearbox ISO."
	docker build --rm -t gearboxworks/iso-maker .
}

clean_container() {
	echo "# Removing Gearbox iso-maker Docker container."
	docker image rm gearboxworks/iso-maker
	echo "# Cleaning up log files and ISOs."
	rm -f build/iso/*.log build/iso/*.iso build/iso/*.md5sum
}

create_iso() {
	echo "# Creating Gearbox ISO."
	docker run --rm -v `pwd`/build/:/build/ -t -i --privileged gearboxworks/iso-maker /build/build-iso.sh "$@"
}

extract_rootfs() {
	echo "# Extracting into build/rootfs."
	if [ -f build/rootfs.changes.tar.gz ]
	then
		rm -rf build/rootfs && \
			mkdir build/rootfs && \
			tar zxf build/rootfs.changes.tar.gz -C build/rootfs
	fi
}

shell_out() {
	echo "# Shelling out to Gearbox iso-maker."
	docker run --rm -v `pwd`/build/:/build/ -t -i --privileged gearboxworks/iso-maker /bin/bash -l
}

list_iso() {
	ISOS="$(find build/iso -type f -name '*.iso')"
	if [ "${ISOS}" == "" ]
	then
		echo "# No ISOs found in ./build/iso"
		exit
	fi

	echo "# List ISOs"
	for iso in $(find build/iso -type f -name '*.iso')
	do
		echo "# ${iso}"
		ls -lh "${iso}" "${iso}.md5sum" 2>/dev/null
		cat "${iso}.md5sum" 2>/dev/null
	done
}


case "$1" in
	'shell'|'bash')
		shell_out
		extract_rootfs
		;;

	'container'|'docker')
		create_container
		;;

	'clean'|'rm'|'remove')
		clean_container
		;;

	'create'|'iso')
		shift
		create_iso "$@"
		extract_rootfs
		;;

	'ls'|'list'|'show')
		list_iso
		;;

	'build')
		clean_container
		create_container
		create_iso "$@"
		extract_rootfs
		;;

	*)
		echo "
# Temporary shell script to build ISOs, (ahead of GoLang).

$0 container	- Create iso-maker Docker container.
$0 clean	- Remove iso-maker Docker container.

$0 iso		- Create ISO from iso-maker Docker container.
$0 list		- Show ISOs along with MD5SUMs.

$0 build		- Perform 'container' & 'iso' in one step.

$0 shell		- Run a shell within the iso-maker Docker container.
"
esac

