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

.venv: $(APP_MAKEFILE)
	python3 -m venv $@ --upgrade-deps
	$@/bin/python -m pip install -U \
		$(if $(DEBUG), $(PYTHON_DEV_PACKAGES), ) \
		$(or $(PYTHON_PACKAGES))
	$(info Activate your venv with: source $@/bin/activate)