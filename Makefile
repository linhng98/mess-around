.POSIX:

.PHONY: metal
metal:
	make -C metal

.PHONY: tools
tools:
	make -C tools

.PHONY: bootstrap
bootstrap:
	make -C bootstrap
