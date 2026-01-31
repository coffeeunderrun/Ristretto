.SUFFIXES:

include vars.mk

IMGDIR = img/$(ARCH)

ifeq ($(ARCH), x86_64)
LIMINE_BOOT := BOOTX64.EFI
endif

.PHONY: all
all: $(IMGDIR)/$(IMAGENAME).img

.PHONY: clean
clean:
	rm -rf $(IMGDIR)/$(IMAGENAME).img
	$(MAKE) -Ckernel clean
# 	$(MAKE) -Crtl clean

.PHONY: distclean
distclean:
	rm -rf img/ vendor/edk2-ovmf
	$(MAKE) -Ckernel distclean
# 	$(MAKE) -Crtl distclean

# Kernel uses its own slim RTL
.PHONY: kernel
kernel: vendor/limine-protocol vendor/uacpi
	$(MAKE) -Ckernel

# RTL for userspace
.PHONY: rtl
rtl:
# 	$(MAKE) -Crtl

.PHONY: run
run: $(IMGDIR)/$(IMAGENAME).img vendor/edk2-ovmf
	$(QEMU) $(QEMUFLAGS) \
		-drive format=raw,file=$< \
		-drive if=pflash,format=raw,unit=0,file=vendor/edk2-ovmf/ovmf-code-$(ARCH).fd,readonly=on \
		-drive if=pflash,format=raw,unit=1,file=vendor/edk2-ovmf/ovmf-vars-$(ARCH).fd

$(IMGDIR)/$(IMAGENAME).img: kernel vendor/limine/limine
	mkdir -p $(IMGDIR)
	dd if=/dev/zero of=$@ bs=1M count=40 \
		&& mformat -i $@ -F :: \
		&& mmd -i $@ ::/EFI ::/EFI/BOOT ::/boot ::/boot/limine \
		&& mcopy -i $@ vendor/limine/$(LIMINE_BOOT) ::/EFI/BOOT \
		&& mcopy -i $@ limine.conf ::/boot/limine \
		&& mcopy -i $@ kernel/bin/$(ARCH)/kernel.elf ::/boot

vendor/edk2-ovmf:
	curl -L https://github.com/osdev0/edk2-ovmf-nightly/releases/latest/download/edk2-ovmf.tar.gz | gunzip | tar -xf - -C vendor

vendor/limine/limine:
	git submodule update --init vendor/limine
	$(MAKE) -Cvendor/limine CC="$(HOST_CC)" CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)" LIBS="$(HOST_LIBS)"

vendor/limine-protocol:
	git submodule update --init vendor/limine-protocol

vendor/uacpi:
	git submodule update --init vendor/uacpi
