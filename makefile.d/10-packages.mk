# Manage software packages
# target names in format <flavor-function>

# The Linux flavor
# Possibilities include Ubuntu, Debian, RHEL, Rocky, Alpine, etc.
LINUX_FLAVOR := $(shell . /etc/os-release; echo $$NAME)

### Development Tools - not installed on prod environments
Ubuntu_DEV_PACKAGES := make vim tree procps psmisc less inotify-tools 
Debian_DEV_PACKAGES := $(UBUNTU_DEV_PACKAGES)
ALL_DEV_PACKAGES = $(or $(DEV_PACKAGES),) $($(LINUX_FLAVOR)_DEV_PACKAGES)

Ubuntu-devtools Debian-devtools: FORCE
	$(SUDO) apt-get install -y $(ALL_DEV_PACKAGES)

devtools: $(LINUX_FLAVOR)-devtools

### Build environment dependencies

Ubuntu_BUILD_PACKAGES := make python3 openssl pandoc amazon-ecr-credential-helper jq

Ubuntu-depends Debian-depends: FORCE
	export DEBIAN_FRONTEND=noninteractive
	$(SUDO) apt-get install -y $(Ubuntu_BUILD_PACKAGES)

depends: $(LINUX_FLAVOR)-depends
	pip install \
		Jinja2