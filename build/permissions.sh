#!/bin/bash


save_permissions() {
	DIR="$1"
	DATABASE=".${DIR}-permissions"

	if [ "${DIR}" != "" ]
	then
		echo -n "Saving permissions in ${DIR} ..."
		find ${DIR} | xargs -i bash -c 'echo "{};$(stat -c "%a;%U;%G" {})"' > ${DATABASE}

		echo "OK - saved $(wc -l .rootfs-permissions | awk '{print$1}') permissions."
	fi
}

restore_permissions() {
	DIR="$1"
	DATABASE=".${DIR}-permissions"

	if [ "${DIR}" != "" ]
	then
		echo -n "Restoring permissions in ${DIR} ..."

		IFS_OLD=$IFS; IFS=$'\n'
		while read -r LINE || [[ -n "${LINE}" ]];
		do
			ITEM="$(echo ${LINE} | cut -d ";" -f 1)"
			PERMISSIONS="$(echo ${LINE} | cut -d ";" -f 2)"
			USER="$(echo ${LINE} | cut -d ";" -f 3)"
			GROUP="$(echo ${LINE} | cut -d ";" -f 4)"

			# Set the file/directory permissions
			chmod $PERMISSIONS ${ITEM} >& /dev/null

			# Set the file/directory owner and groups
			chown $USER:$GROUP ${ITEM} >& /dev/null

		done < ${DATABASE}
		IFS=$IFS_OLD

		echo "OK - Restored $(wc -l ${DATABASE}) permissions."
	fi
}


################################################################################
CMD="$1"
DIR="$2"

if [ "${DIR}" == "" ]
then
	DIR="rootfs"
fi

case "${CMD}" in
	'save')
		save_permissions ${DIR}
		;;

	'restore')
		restore_permissions ${DIR}
		;;

	*)
		echo "$0 <save | restore> [directory]"
		;;
esac

# chown -fR gearbox:gearbox rootfs/home/gearbox/ rootfs/home/build/ rootfs/usr/local/ rootfs/etc/gearbox/ rootfs/var/lib/gearbox/ rootfs/var/lib/cache/fallback/

