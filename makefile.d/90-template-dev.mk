# Targets relevant to developing the template

.git/info/exclude: FORCE
	mkdir -p $(dir $@)
	cd $(dir $@)
	ln -sf ../../.exclude exclude

template-dev: FORCE .git/info/exclude