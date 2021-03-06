all: help

name = $(shell basename $(shell pwd))
prefix = /usr/local

PATH_INSTALL_SHARE = $(prefix)/share/pyproject

help:
	@echo '=== Targets'
	@echo
	@echo '# initialize pyproject from template'
	@echo '  init [ name=<name> ] 			# default: name=$$(basename $$(pwd))'
	@echo
	@echo '# install pyproject-common components'
	@echo '  install [ prefix=path/to/usr ]         # default: prefix=$(value prefix)'

init: PYPROJECT_SHARE_PATH ?= /usr/share/pyproject
init: clean

ifeq ($(shell basename $(shell pwd)),pyproject)
	$(error won't initialize pyproject in-place)
endif
	rm -f $$(find -maxdepth 1 -type f)
	rm -rf $$(find -mindepth 1 -maxdepth 1 -type d | grep -v template)

	rsync -a template/ ./
	rm -rf template/

	$(PYPROJECT_SHARE_PATH)/rename.sh pyproject $(name)
	git init 
	git add .
	git commit -m "Initialized project '$(name)' from pyproject template"

install:
	python setup.py install --prefix $(prefix) --install-layout=deb

	mkdir -p $(PATH_INSTALL_SHARE)
	cp -a share/* $(PATH_INSTALL_SHARE)

uninstall:
	rm -rf $(PATH_INSTALL_SHARE)

clean:
	rm -rf build

.PHONY: help init install uninstall clean 
