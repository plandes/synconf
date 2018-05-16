PROG=		synconf
INST_DIR=	/usr/local/bin
LOCAL_INST_DIR=	$(HOME)/opt/lib/perl/$(PROG)
README=		README.md
POD2MARK=	pod2markdown 
POD2MAN=	pod2man

.PHONY:	instp2mark
instp2mark:
		cpan install pod2markdown


.PHONY: doc
doc:
		mkdir -p doc
		$(POD2MARK) $(PROG) > doc/pod.md

.PHONY: install
install:
		sudo install $(PROG) $(INST_DIR)

.PHONY:	localinstall
localinstall:
		mkdir -p $(LOCAL_INST_DIR)/bin $(LOCAL_INST_DIR)/man1
		cp $(PROG) $(LOCAL_INST_DIR)/bin
		$(POD2MAN) $(PROG) > $(LOCAL_INST_DIR)/man1/$(PROG).1
