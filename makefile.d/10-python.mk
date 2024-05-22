# Python development

# Packages useful for development
PYTHON_DEV_PACKAGES := \
	ipython \
	httpie \
	pytest \
	rpdb \
	debugpy \
	gevent \
	# EOL

PYTHON_CUSTOM_PACKAGES := $(call read_config, python_packages)

.venv:
	python3 -m venv $@ --upgrade-deps
	$@/bin/python -m pip install -U $(if $(DEBUG), $(PYTHON_DEV_PACKAGES), ) $(PYTHON_CUSTOM_PACKAGES)

