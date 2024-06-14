# All docker related targets

#.build-deps: Dockerfile makefile ssl.conf $(shell find webhooks -type f -name "*.py")
#	touch $@

IMAGETAG := $(if $(DEBUG),debug,latest)
IMAGENAME := $(PROJECTNAME):$(IMAGETAG)
IMAGENAME_REMOTE = $(REPOSITORY_URI):$(IMAGETAG)
CONTAINERARCHIVE := $(PROJECTNAME)-$(IMAGETAG)-image.tar.gz
BASEIMAGE ?=

container: FORCE dockerfile $(DEBUG_VAR)
	docker image build -t $(IMAGENAME) . \
		$(if $(DEBUG),--build-arg debug=1) \
		$(if $(BASEIMAGE),--build-arg baseimage=$(BASEIMAGE))

container.tar.gz: container
	docker save $(IMAGENAME) | gzip >$@

REPOSITORY_URI = $(shell \
	aws ecr describe-repositories \
		--repository-names rsdf \
		--query "repositories[0].repositoryUri" \
		--output text \
)
REPOSITORY = $(firstword $(subst /, ,$(REPOSITORY_URI)))

ecr-repository: FORCE
	aws ecr describe-repositories \
		--repository-names "$(PROJECTNAME)" \
		&> /dev/null
	if [ $$? -ne 0 ]; then
		aws ecr create-repository 
			--repository-name "$(PROJECTNAME)"
	fi
	j=~/.docker/config.json
	if [ ! -f $$j ]; then echo { } > $$j; fi
	jq '.credHelpers += {"$(REPOSITORY)": "ecr-login"}' $$j > $$j.tmp && mv $$j.tmp $$j

container-upload: FORCE $(DEBUG_VAR) container
	docker image tag $(IMAGENAME) $(IMAGENAME_REMOTE)
	docker image push $(IMAGENAME_REMOTE)

# Delete all docker images not currently in use
flush-docker-images:
	all_images=$$(docker images -q | sort | uniq)
	in_use_images=$$(docker ps -q | xargs docker inspect --format='{{.Image}}' | cut -d: -f2 | cut -c1-12 | sort | uniq)
	unused_images=$$(comm -23 <(echo "$$all_images") <(echo "$$in_use_images"))
	for i in $$unused_images; do docker rmi -f $$i; done