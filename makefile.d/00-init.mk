SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# This target is used instead of .PHONY for modularity
# See: https://www.gnu.org/software/make/manual/html_node/Force-Targets.html
FORCE:

# Read a config value
define read_config
	$(shell python -c "import yaml,sys; print(' '.join(yaml.safe_load(open('config.yml')).get(sys.argv[1],'')))" $(1))
endef

# Set the DEBUG variable in your environment if you want extra dev tools
DEBUG ?= false
DEBUG_VAR := .DEBUG
$(DEBUG_VAR): FORCE
	@if [ "$$(cat $@ 2>/dev/null)" != "$(DEBUG)" ]; then \
		echo "$(DEBUG)" > $@; \
	fi

# The name of the project
PROJECTNAME := $(notdir $(CURDIR))

all: $(CONTAINERARCHIVE) README.pdf

clean: FORCE
	git clean -f
	docker image prune -f