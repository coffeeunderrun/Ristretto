.SUFFIXES:

include ../vars.mk

override FPCFLAGS += -vh-n-w-

kernel: fpmake
	./fpmake install --cpu=$(TARGET_ARCH) --os=embedded --options="$(FPCFLAGS)" --prefix=../kernel

fpmake: fpmake.pas
	$(HOST_FPC) $(HOST_FPCFLAGS) -o$@ $<

.PHONY: clean
clean:
	rm -rf units/$(TARGET_ARCH)-linux ../kernel/lib/fpc/$(FPCVERSION)/units/$(TARGET_ARCH)-linux

.PHONY: distclean
distclean:
	rm -rf units/ ../kernel/lib fpmake *.o *.fpm
