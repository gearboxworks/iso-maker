# iso-maker

Just run `iso-maker.sh` for instructions.

## Files and directories

- `Dockerfile`	- The Docker container generation file. This creates the ISO.
- `README.md`	- This file.
- `build/`	- Holds all files used to generate the ISO and is mounted within the Docker container as `/build`.
- `build/aports/`	- A copy of the Alpine Linux aports repository.
- `build/go/`	- Used to regenerate any GoLang executables that are used within the ISO.
- `build/iso/`	- Contains the ISO image, MD5SUM and log files.
- `build/build-iso.sh`	- This is used to generate the ISO and handles extracting rootfs, etc. Also calls the mkimage script.
- `build/mkimg.*.sh`	- The mkimg.* scripts that are called from mkimage.sh
- `build/genapkovl-*.sh`	- Another script that's used to munge the rootfs ISO. It's called from the mkimg.* scripts.
- `build/repositories-*`	- Alpine repository overrides.
- `build/apks-*.txt`	- Packages that are installed within the ISO.
- `build/rootfs.changes.tar.gz`	- This file is used to override changes within the ISO.
- `docker_files/`	- Holds all files used to generate the Docker container.
- `docker_files/build/`	- Is copied inside the Docker container.
- `docker_files/build/build-docker.sh`	- Script that generates the Docker container.
- `docker_files/build/apks.txt`	- Packages that are installed within the Docker container.
- `docker_files/build/rootfs/`	- Changes to be made to / of the Docker container.
- `iso-maker.sh`	- A handy script that will make life easier.


### iso-maker help

`./iso-maker.sh container`	- Create iso-maker Docker container.

`./iso-maker.sh clean`		- Remove iso-maker Docker container.

`./iso-maker.sh iso`		- Create ISO from iso-maker Docker container.

`./iso-maker.sh list`		- Show ISOs along with MD5SUMs.

`./iso-maker.sh build`		- Perform 'container' & 'iso' in one step.

`./iso-maker.sh shell`		- Run a shell within the iso-maker Docker container.


## Process summary

The ISO maker process that happens within the Docker container is as follows:

- Extract build/rootfs.changes.tar.gz into /tmp/rootfs every time a new container starts up.
- Execute build/build-iso.sh
- This will compress /tmp/rootfs into build/rootfs.changes.tar.gz and run the ISO maker generator script.


## Build ISO from scratch

If you haven't built the Docker container, then you will need to build it. You only need to do this once and not every time.

`./iso-maker.sh container`

Then you can regenerate ISOs at will.

`./iso-maker.sh iso`

You could also do this, if you don't have a Docker container already. Remember that you don't need to rebuild the Docker container every time as it remains very static.

`./iso-maker.sh build`


## Making changes to rootfs.changes.tar.gz

It's critical that you don't extract this file to anything other than this Docker container. As this will change important file permissions.

If you want to make changes to this file, then do this:

`./iso-maker.sh shell`

This will drop into the Docker container, extract this file automatically to `/tmp/rootfs`. From there you can change whatever you want.

There are some directories that are regenerated from GitHub during the ISO build.

`/tmp/rootfs/var/lib/cache/fallback/opt/gearbox` - Is pulled from GitHub. So don't expect any changes under that directory to be persistent. Instead make changes to the box-scripts GitHub repo.

`/tmp/rootfs/var/lib/cache/fallback/home/gearbox/projects/default` - Isn't currently pulled from Git, but probably should. This contains the legacy WPLib-Box WordPress install.

When you `exit` the Docker container, it will automatically:
- Save a copy of the current `build/rootfs.changes.tar.gz`.
- Tarball `/tmp/rootfs` into `build/rootfs.changes.tar.gz`.

This will allow you to drop into a shell, make arbitrary changes to the '/' of the ISO, exit and rebuild.

To avoid dropping in and out of the Docker container during many changes, you can simply run `/build/build-iso.sh` from within the Docker container shell.

This is the script that is run as default, and it'll automatically tarball up `/tmp/rootfs` and place it in `/build/rootfs.changes.tar.gz`

