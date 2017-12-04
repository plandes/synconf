PROG=		synconf
INST_DIR=	/usr/local/bin
README=		README.md
P2M=		pod2markdown 

.PHONY: doc
doc:
	$(P2M) $(PROG) > doc/pod.md

.PHONY: install
install:
	sudo install $(PROG) $(INST_DIR)
