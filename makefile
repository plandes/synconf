PROG=		synconf
INST_DIR=	/usr/local/bin
README=		README.md

.PHONY: doc
doc:
	pod2markdown $(PROG) > $(README)

.PHONY: install
install:
	sudo install $(PROG) $(INST_DIR)
