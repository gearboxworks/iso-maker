# iso-maker

Just run `iso-maker.sh` for instructions.

## Process summary

The ISO maker process that happens within the Docker container is as follows:

- Extract build/rootfs.changes.tar.gz into /tmp/rootfs every time a new container starts up.
- Execute build/build-iso.sh
- This will compress /tmp/rootfs into build/rootfs.changes.tar.gz and run the ISO maker generator script.

