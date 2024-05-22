# All docker related targets

#.build-deps: Dockerfile makefile ssl.conf $(shell find webhooks -type f -name "*.py")
#	touch $@

IMAGETAG := $(if $(DEBUG),debug,latest)
IMAGENAME := $(PROJECTNAME):$(IMAGETAG)
CONTAINERARCHIVE := $(PROJECTNAME)-image-$(IMAGETAG).tar.gz

# This produces a flag file
container: dockerfile $(DEBUG_VAR)
	docker image build -t $(IMAGENAME) . $(if $(DEBUG), --build-arg debug=1)
	touch $@

container.tar.gz: container
	docker save $(IMAGENAME) | gzip >$@

# Run the docker image in the background
#rund: $(IMAGENAME) FORCE
#	docker rm -f $(PROJECTNAME) 2>/dev/null
#	docker run \
#	  -d \
#	  -p 8000:80 \
#	  --name $(PROJECTNAME) \
#	  -v $(PWD)/nginx.conf:/etc/nginx/nginx.conf:ro \
#	  -v ${PWD}/test-ca.crt:/test-ca.crt \
#      -e AWS_CA_BUNDLE=/test-ca.crt \
#	  $(IMAGENAME)


# Run docker container for test and verification
#runt: # out/webhooks-latest.tar.gz test-ca.crt build
#	docker rm -f document-webhooks 2>/dev/null
#	gunzip -c out/webhooks-latest.tar.gz | docker load
#	docker run \
#		-d \
#		-p 8000:80 \
#		--name document-webhooks \
#		-p 8001:443 \
#    	-v ${PWD}/server.crt:/root/server.crt \
#    	-v ${PWD}/server.key:/root/server.key \
#		-v ${PWD}/test-ca.crt:/test-ca.crt \
#		-e AWS_CA_BUNDLE=/test-ca.crt \
#		document-webhooks:latest
#	source .venv/bin/activate
#	sleep 1
#	http  $$HOSTNAME:8000/metadata id==/testfile APIKEY:$$APIKEY
#	https $$HOSTNAME:8001/metadata id==/testfile APIKEY:$$APIKEY
