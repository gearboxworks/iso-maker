#!/bin/bash

case "$1" in
	'start'|'startup'|'up')
		# Startup the VM.
		VBoxManage startvm Gearbox --type headless && telnet localhost 2023
		;;

	'stop'|'shutdown'|'halt')
		# Shutting down the VM.
		VBoxManage controlvm Gearbox acpipowerbutton
		;;

	'ssh')
		# SSH to Gearbox.
		ssh -p 2222 root@localhost
		;;

	*)
		echo "
		################
		# Startup the VM
		VBoxManage startvm Gearbox --type headless

		# You will need to connect to the console for it to boot.
		telnet localhost 2023

		# You can also SSH into the NAT NIC.
		ssh -p 2222 root@localhost
		# Or SSH into the WordPress facing NIC.


		######################
		# Shutting down the VM
		VBoxManage controlvm Gearbox acpipowerbutton
		"
esac

