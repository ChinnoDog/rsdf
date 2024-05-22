# There is no need to modify this file. Add makefiles in `makefile.d`.

MAKEFILES := $(shell find ./makefile.d -type f -name "*.mk" | sort)
include $(MAKEFILES)