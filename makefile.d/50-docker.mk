# All docker related targets

#.build-deps: Dockerfile makefile ssl.conf $(shell find webhooks -type f -name "*.py")
#	touch $@

IMAGETAG := $(if $(DEBUG),debug,latest)
IMAGENAME := $(PROJECTNAME):$(IMAGETAG)
CONTAINERARCHIVE := $(PROJECTNAME)-image-$(IMAGETAG).tar.gz
BASEIMAGE ?=

# This produces a flag file
container: dockerfile $(DEBUG_VAR)
	docker image build -t $(IMAGENAME) . \
		$(if $(DEBUG),--build-arg debug=1) \
		$(if $(BASEIMAGE),--build-arg baseimage=$(BASEIMAGE))
	touch $@

container.tar.gz: container
	docker save $(IMAGENAME) | gzip >$@