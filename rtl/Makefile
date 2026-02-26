.SUFFIXES:

include ../vars.mk

override FPCFLAGS += -vh-n-w-

.PHONY: kernel
kernel: fpmake-kernel
	./fpmake-kernel install --cpu=$(TARGET_ARCH) --os=embedded --options="$(FPCFLAGS)" --prefix=../kernel

.PHONY: module
module: fpmake-module
	./fpmake-module install --cpu=$(TARGET_ARCH) --os=embedded --options="$(FPCFLAGS)" --prefix=../modules

%: %.pas
	$(HOST_FPC) $(HOST_FPCFLAGS) -o$@ $<

.PHONY: clean
clean: clean-kernel clean-module

.PHONY: clean-kernel
clean-kernel: fpmake-kernel
	./fpmake-kernel clean --cpu=$(TARGET_ARCH) --os=embedded

.PHONY: clean-module
clean-module: fpmake-module
	./fpmake-module clean --cpu=$(TARGET_ARCH) --os=embedded

.PHONY: distclean
distclean: distclean-kernel distclean-module

.PHONY: distclean-kernel
distclean-kernel: fpmake-kernel
	./fpmake-kernel distclean

.PHONY: distclean-module
distclean-module: fpmake-module
	./fpmake-module distclean
