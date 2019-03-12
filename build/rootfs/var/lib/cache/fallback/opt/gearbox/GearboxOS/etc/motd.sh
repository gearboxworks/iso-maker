#!/bin/sh

if [ -e /opt/gearbox/version ]
then
	VERSION="$(cat /opt/gearbox/version)"
else
	VERSION="Unknown"
fi

if [ -e /opt/gearbox/last-commit-date ]
then
	COMMIT="($(cat /opt/gearbox/last-commit-date))"
else
	COMMIT=""
fi

echo "Welcome to Gearbox $VERSION. ${COMMIT}"
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
echo "   - https://help.gearbox.works/"
tput sgr0
echo ""

echo "Connect to your Gearbox on either:"
echo ""
tput setaf 3
echo "   - https://gearbox.local/"
echo "   - http://gearbox.local/"
tput sgr0
echo ""

