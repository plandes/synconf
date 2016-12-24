PROG=	synconf
README=	README.md

.PHONY: doc
doc:
	pod2markdown $(PROG) > $(README)

.PHONY: clean
clean:
	rm -f $(README)
