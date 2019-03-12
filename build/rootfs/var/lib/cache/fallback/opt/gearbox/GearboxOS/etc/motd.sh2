#!/bin/sh

if [ -e /opt/gearbox/version ]
then
        VERSION="`cat /opt/gearbox/version`"
else
        VERSION="Unknown"
fi

echo "Welcome to GearBox $VERSION."
echo ""

tput setaf 2
cat <<EOF
EOF
tput sgr0

tput setaf 6
echo "        Next Generation Developer Productivity Platform"
tput sgr0
echo ""

echo -n "Run "
tput setaf 3
echo -n "box help"
tput sgr0
echo " for help, or see the docs at:"
echo ""
tput setaf 3
echo "   - http://gearbox.github.io/"
tput sgr0
echo ""

tput setaf 3
echo "Connect to your GearBox:"
echo "   - https://gearbox.local/"
echo "   - http://gearbox.local/"
tput sgr0
echo ""

exit 0


ip="$(ip addr show eth1 | awk '/inet /{gsub(/\/.*/, "", $2); print$2}')"
if [ "${ip}" != "" ]
then
	tput setaf 3
	echo "Connect to your GearBox:"
	echo "   - http://${ip}/"
	tput sgr0
	echo ""
fi

exit 0

