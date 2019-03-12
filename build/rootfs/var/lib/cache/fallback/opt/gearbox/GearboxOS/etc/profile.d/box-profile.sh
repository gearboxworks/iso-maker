#!/bin/bash

if [ -x /opt/gearbox/cli/commands/check-mounts ]
then
	/opt/gearbox/cli/commands/check-mounts
fi

PATH="/opt/gearbox/bin:/opt/gearbox/sbin:$HOME/bin:$PATH"

if ! shopt -oq posix
then
	if [ -f /usr/share/bash-completion/bash_completion ]
	then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]
	then
		. /etc/bash_completion
	fi
fi

HISTCONTROL=erasedups:ignoreboth
shopt -s histappend

# 0.17.0 - Defines the base project path.
BOX_PROJECTS_ROOT="/home/gearbox/projects"
export BOX_PROJECTS_ROOT

# 0.17.0 - Defines the default project to start.
DEFAULT_PROJECT="default"
export DEFAULT_PROJECT

# Change inital SSH directory to be /home/gearbox/projects/default
if [ -d "${BOX_PROJECTS_ROOT}/${DEFAULT_PROJECT}" ]
then
	cd "${BOX_PROJECTS_ROOT}/${DEFAULT_PROJECT}"
fi

