.SUFFIXES:

include ../vars.mk

override FPCFLAGS += -vh-n-w-

.PHONY: kernel
kernel: fpmake
	./fpmake install --cpu=$(TARGET_ARCH) --os=embedded --options="$(FPCFLAGS)" --prefix=../kernel

fpmake: fpmake.pas
	$(HOST_FPC) $(HOST_FPCFLAGS) -o$@ $<

.PHONY: clean
clean:
	rm -rf units/$(TARGET_ARCH)-embedded

.PHONY: distclean
distclean:
	rm -rf units/ fpmake *.o *.fpm
