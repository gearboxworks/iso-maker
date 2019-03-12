#/usr/bin/env bash

LESS="-SinR"
export LESS

################################################################################ 
# Command completion for 'box'
_box()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}


	case "${COMP_WORDS[1]}" in
		'component')
			# /opt/gearbox/bin/box component help
			_box_component
			return 0
			;;

		'container')
			# /opt/gearbox/bin/box component help
			_box_component
			return 0
			;;

		'database')
			COMPREPLY=($(compgen -W "backup import chunk unchunk credentials dbname username password" -- $cur))
			return 0
			;;

		'startup')
			COMPREPLY=($(compgen -W "" -- $cur))
			return 0
			;;

		'restart')
			COMPREPLY=($(compgen -W "" -- $cur))
			return 0
			;;

		'shutdown')
			COMPREPLY=($(compgen -W "" -- $cur))
			return 0
			;;

		'status')
			COMPREPLY=($(compgen -W "" -- $cur))
			return 0
			;;

		'shell')
			COMPREPLY=($(compgen -W "" -- $cur))
			return 0
			;;

		'version')
			COMPREPLY=($(compgen -W "" -- $cur))
			return 0
			;;

		'self-update')
			# compgen -W "$(git --git-dir=/opt/gearbox/.git tag)" -- $cur
			local REPLY="$(git --git-dir=/opt/gearbox/.git for-each-ref --format='%(refname:short)' | cut -d/ -f2- | sort -u | grep '\.')"
			COMPREPLY=($(compgen -W "$REPLY" -- $cur))
			return 0
			;;

		'test')
			_box_test
			return 0
			;;

		'help')
			COMPREPLY=($(compgen -W "" -- $cur))
			return 0
			;;
	esac

	COMPREPLY=($(compgen -W "database component comp container startup restart shutdown status shell version self-update test help" -- $cur))
}
complete -F _box box



################################################################################
# Command completion for 'box component'
_box_component()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	case "$prev" in
		'stop'|'restart')
			_box_component_running
			return 0
			;;

		'start')
			_box_component_stopped
			return 0
			;;

		'list'|'ls'|'inspect'|'log'|'uninstall'|'deactivate'|'refresh')
			_box_component_all
			return 0
			;;

		'pull'|'install'|'activate')
			_box_component_dockerhub
			return 0
			;;
	esac

	COMPREPLY=($(compgen -W "install uninstall activate deactivate start stop list ls refresh update available shutdown reallyclean inspect log pull" -- $cur))
	return 0
}

_box_component_running()
{
	local cur=${COMP_WORDS[COMP_CWORD]}

	COMPREPLY=($(compgen -W "$(docker container ls -af label=container.organization=gearboxworks -f status=running --format='{{.Image}}')" -- $cur))
	return 0
}


_box_component_stopped()
{
	local cur=${COMP_WORDS[COMP_CWORD]}

	COMPREPLY=($(compgen -W "$(docker container ls -af label=container.organization=gearboxworks -f status=created -f status=exited --format='{{.Image}}')" -- $cur))
	return 0
}


_box_component_all()
{
	local cur=${COMP_WORDS[COMP_CWORD]}

	COMPREPLY=($(compgen -W "$(docker container ls -af label=container.organization=gearboxworks --format='{{.Image}}')" -- $cur))
	return 0
}


_box_component_dockerhub()
{
	local IMAGES
	local IMAGE_NAME
	local VERSIONS
	local IMAGE_VERSION
	local REPLY
	local cur=${COMP_WORDS[COMP_CWORD]}

	IMAGES="$(jq -r '.results|.[]|.name' /etc/gearbox/repositories.json | sort -u)"
	for IMAGE_NAME in $IMAGES
	do
		if [ -f /etc/gearbox/images/${IMAGE_NAME}.json ]
		then
			VERSIONS="$(jq -r '.results|.[]|.name' /etc/gearbox/images/${IMAGE_NAME}.json)"
			for IMAGE_VERSION in $VERSIONS
			do
				if [ "${IMAGE_VERSION}" != "latest" ]
				then
					REPLY="$REPLY gearboxworks/${IMAGE_NAME}:$IMAGE_VERSION"
				fi
			done
		fi
	done

	COMPREPLY=($(compgen -W "$REPLY" -- $cur))
	return 0
}





################################################################################
# Command completion for 'box test'
_box_test()
{
	local cur=${COMP_WORDS[COMP_CWORD]}
	local prev=${COMP_WORDS[COMP_CWORD-1]}

	case "$prev" in
		'list'|'ls')
			_box_component_running
			return 0
			;;


		'run')
			_box_test_files
			return 0
			;;
	esac

	COMPREPLY=($(compgen -W "list ls run" -- $cur))
	return 0
}

_box_test_files()
{
	local cur=${COMP_WORDS[COMP_CWORD]}

	COMPREPLY=($(compgen -W "$(find /opt/gearbox/cli/tests -maxdepth 1 -type f -printf '%f\n')" -- $cur))
	return 0
}


