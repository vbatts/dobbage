
prgnam := dobbage
version := 1.5

ruby := ruby
setup_rb := setup.rb

ifndef DESTDIR
	DESTDIR := /
endif 

default: config

.PHONY: config
config: $(setup_rb)
	$(ruby) $(setup_rb) config

.PHONY: setup
setup: $(setup_rb) config
	$(ruby) $(setup_rb) setup

.PHONY: install
install: $(setup_rb) setup
	$(ruby) $(setup_rb) install --prefix=$(DESTDIR)

.PHONY: test
test: $(setup_rb)
	$(ruby) $(setup_rb) test

.PHONY: dist
dist: distclean
	rm -rf dist/$(prgnam)-$(version) && \
	mkdir -p dist/$(prgnam)-$(version) && \
	find . ! -name build ! -regex '.*\.git.*' ! -regex '.*\.swp' ! -regex './dist.*' -print0 | cpio -dump --null ./dist/$(prgnam)-$(version)/ && \
	cd dist && \
	tar cvzf $(prgnam)-$(version).tar.gz $(prgnam)-$(version)/ && \
	cd -
	@echo "Created ./dist/$(prgnam)-$(version).tar.gz"


clean: clean.cruft
	$(ruby) $(setup_rb) clean

clean.cruft:
	find . -type f -name '*~' | xargs rm

distclean: clean.cruft
	$(ruby) $(setup_rb) distclean

