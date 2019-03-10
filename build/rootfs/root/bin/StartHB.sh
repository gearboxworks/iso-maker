#!/bin/bash

PATH="/opt/gearbox/bin:/opt/gearbox/sbin:/root/go/bin:$PATH"

CMD="$(which GearboxHeartbeat)"

if [ -x "${CMD}" ]
then
	exec ${CMD} api --vm
fi

# Avoid respawning too quickly.
sleep 5
