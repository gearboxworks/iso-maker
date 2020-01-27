#
# Standard version level Makefile used to build a Docker container for Gearbox - https://github.com/gearboxworks/gearbox/
#

.ONESHELL:

define osSystem
$(shell uname)
endef

ifeq ($(osSystem),Linux)
LOG_ARGS	:= -t 10
else
LOG_ARGS	:= -r -t 10
endif

################################################################################
# Set global variables from container file.
ISOS	:= $(wildcard build/iso/*.iso)
PWD	:= $(shell pwd)

# LOGFILE := $(NAME)-$(shell date +'%Y%m%d-%H%M%S').log
LOGFILE := iso-maker.log


.PHONY: build push release clean list log inspect test create shell run start stop rm

################################################################################
# Image related commands.
default: all

all:
	@echo "# Temporary shell script to build ISOs, (ahead of GoLang)."
	@echo ""
	@echo "clean		- Remove iso-maker Docker container."
	@echo "container	- Create iso-maker Docker container."
	@echo ""
	@echo "iso		- Create ISO from iso-maker Docker container."
	@echo "shell		- Run a shell within the iso-maker Docker container."
	@echo "list		- Show ISOs along with MD5SUMs."
	@echo ""
	@echo "build		- Perform Build process as below."
	@echo ""
	@echo "release		- Perform Build process as below & release."
	@echo "push		- Push changes to GitHub."
	@echo ""
	@echo "Build process:"
	@echo "	make clean"
	@echo "	make container"
	@echo "	make iso"
	@echo "	make list"
	@echo "	make test"


################################################################################
container:
	@echo "# Gearbox: Building Docker Greabox ISO creation container."
	@script $(LOG_ARGS) logs/$(LOGFILE) docker build --rm -t gearboxworks/iso-maker docker-image
	@echo "Gearbox: Log file saved to \"logs/$(LOGFILE)\""


################################################################################
list:
	@echo "# Gearbox: Docker container:"
	@docker image ls -q gearboxworks/iso-maker
	@echo "# Gearbox: ISO files:"
	@make build/iso/*.iso

%.md5sum: %.iso
	@md5sum $< > $@
	@echo "# Gearbox: $<"
	@ls -lh $< $@
	@cat $@


################################################################################
clean:
	@echo "# Gearbox: Removing Gearbox iso-maker Docker container."
	@docker image rm -f gearboxworks/iso-maker
	@echo "# Gearbox: Cleaning up log files and ISOs."
	@rm -f build/iso/*.log build/iso/*.iso build/iso/*.md5sum


################################################################################
push:
	@if [ -d .git ]; then echo "# Gearbox: Pushing changes to GitHub."; git commit -m "Release commit." .. && git push; fi

	@echo "# Gearbox: Pushing changes to DockerHub."
	-docker push $(IMAGE_NAME):$(VERSION)


################################################################################
build:
	@make clean
	@make container
	@make iso
	@make list


################################################################################
release:
	@make build
	@make push


################################################################################
iso:
	@echo "# Gearbox: Creating Gearbox ISO."
	@docker run --rm -v $(PWD)/build/:/build/ -t -i --privileged gearboxworks/iso-maker /bin/bash -l /build/build-iso.sh "$@"



shell:
	@echo "# Gearbox: Shelling out to Gearbox iso-maker."
	@docker run --rm -v $(PWD)/build/:/build/ -t -i --privileged gearboxworks/iso-maker /bin/bash -l

