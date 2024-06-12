SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Make all variables available in subshell environments
# This produces warnings that can't be supressed that look like this:
#	warning: undefined variable '1'
export

# This target is used instead of .PHONY for modularity
# See: https://www.gnu.org/software/make/manual/html_node/Force-Targets.html
FORCE:

# Read a value from a yaml file
# $(call read_yaml,key,filename)
#define read_yaml
#	$(shell python -c "import yaml,sys; print(' '.join(yaml.safe_load(open(sys.argv[2])).get(sys.argv[1],'')))" $(1))
#endef

# Set the DEBUG variable in your environment if you want extra dev tools
DEBUG ?= false
DEBUG_VAR := .DEBUG
$(DEBUG_VAR): FORCE
	@if [ "$$(cat $@ 2>/dev/null)" != "$(DEBUG)" ]; then \
		echo "$(DEBUG)" > $@; \
	fi

# The name of the project
PROJECTNAME := $(notdir $(CURDIR))

# The default target is defined by the project
.DEFAULT_GOAL := all

# Make myapp.mk into optional dependency
APP_MAKEFILE := $(wildcard makefile.d/myapp.mk)

# sudo doesn't exist in every environment
SUDO := $(shell which sudo)

# Python for rendering jinja2 templates
# Call with $(call python,render_template,$<,$@)
define render_template
import jinja2, os, sys
env = jinja2.Environment(loader=jinja2.FileSystemLoader('.'))
template = env.get_template(sys.argv[1])
output = template.render(os.environ)
os.makedirs(os.path.dirname(sys.argv[2]), exist_ok=True)
with open(sys.argv[2], 'w') as f: f.write(output)
endef

define python_2p
@python -c "$(value $(1))" "$(2)" "$(3)"
endef

clean: FORCE
	git clean -f
	rm -rf .venv
	docker image prune -f