.SUFFIXES:

include vars.mk

IMGDIR = img/$(TARGET_ARCH)
ISODIR = iso/$(TARGET_ARCH)

ISOFLAGS := -as mkisofs -R -r -J -hfsplus -apm-block-size 2048 \
  --efi-boot boot/limine/limine-uefi-cd.bin -efi-boot-part --efi-boot-image --protective-msdos-label

ifeq ($(TARGET_ARCH), x86_64)
  LIMINE_BOOT := BOOTX64.EFI BOOTIA32.EFI
  ISOFLAGS += -b boot/limine/limine-bios-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table
else ifeq ($(TARGET_ARCH), aarch64)
  LIMINE_BOOT := BOOTAA64.EFI
  $(error "Target aarch64 is not currently supported.")
else ifeq ($(TARGET_ARCH), loongarch64)
  LIMINE_BOOT := BOOTLOONGARCH64.EFI
  $(error "Target loongarch64 is not currently supported.")
else ifeq ($(TARGET_ARCH), riscv64)
  LIMINE_BOOT := BOOTRISCV64.EFI
  $(error "Target riscv64 is not currently supported.")
else
  $(error "Unsupported target: $(TARGET_ARCH)")
endif

.PHONY: all
all: iso

.PHONY: clean
clean:
	rm -rf $(IMGDIR)/ $(ISODIR)/
	$(MAKE) -Ckernel clean
	$(MAKE) -Crtl clean

.PHONY: distclean
distclean:
	rm -rf img/ iso/ vendor/edk2-ovmf/
	$(MAKE) -Ckernel distclean
	$(MAKE) -Crtl distclean

.PHONY: run
run: $(ISODIR)/$(IMAGENAME).iso vendor/edk2-ovmf
	$(QEMU) $(QEMUFLAGS) -cdrom $< \
		-drive if=pflash,format=raw,unit=0,file=vendor/edk2-ovmf/ovmf-code-$(TARGET_ARCH).fd,readonly=on \
		-drive if=pflash,format=raw,unit=1,file=vendor/edk2-ovmf/ovmf-vars-$(TARGET_ARCH).fd

.PHONY: run-img
run-img: $(IMGDIR)/$(IMAGENAME).img vendor/edk2-ovmf
	$(QEMU) $(QEMUFLAGS) -hda $< \
		-drive if=pflash,format=raw,unit=0,file=vendor/edk2-ovmf/ovmf-code-$(TARGET_ARCH).fd,readonly=on \
		-drive if=pflash,format=raw,unit=1,file=vendor/edk2-ovmf/ovmf-vars-$(TARGET_ARCH).fd

.PHONY: iso
iso: $(ISODIR)/$(IMAGENAME).iso

.PHONY: img
img: $(IMGDIR)/$(IMAGENAME).img

.PHONY: kernel
kernel: rtl-kernel vendor/limine-protocol vendor/uacpi
	$(MAKE) -Ckernel

.PHONY: rtl-kernel
rtl-kernel:
	$(MAKE) -Crtl kernel

$(ISODIR)/$(IMAGENAME).iso: kernel vendor/limine/limine
	mkdir -p $(ISODIR)/root $(ISODIR)/root/boot/limine $(ISODIR)/root/EFI/BOOT
	cp $(addprefix vendor/limine/, $(LIMINE_BOOT)) $(ISODIR)/root/EFI/BOOT
	cp limine.conf $(ISODIR)/root/boot/limine
	cp kernel/bin/$(TARGET_ARCH)/kernel $(ISODIR)/root/boot
	cp assets/kernel.psf $(ISODIR)/root/boot
ifeq ($(TARGET_ARCH), x86_64)
	cp $(addprefix vendor/limine/, limine-bios.sys limine-bios-cd.bin limine-uefi-cd.bin) $(ISODIR)/root/boot/limine/
	xorriso $(ISOFLAGS) -o $@ $(ISODIR)/root \
		&& ./vendor/limine/limine bios-install $@
else
	cp vendor/limine/limine-uefi-cd.bin $(ISODIR)/root/boot/limine
	xorriso $(ISOFLAGS) -o $@ $(ISODIR)/root
endif

$(IMGDIR)/$(IMAGENAME).img: kernel vendor/limine/limine
	mkdir -p $(IMGDIR)
	dd if=/dev/zero of=$@ bs=1M count=40 \
		&& mformat -i $@ -F :: \
		&& mmd -i $@ ::/EFI ::/EFI/BOOT ::/boot ::/boot/limine \
		&& mcopy -i $@ $(addprefix vendor/limine/, $(LIMINE_BOOT)) ::/EFI/BOOT \
		&& mcopy -i $@ limine.conf ::/boot/limine \
		&& mcopy -i $@ kernel/bin/$(TARGET_ARCH)/kernel ::/boot

vendor/edk2-ovmf:
	curl -L https://github.com/osdev0/edk2-ovmf-nightly/releases/latest/download/edk2-ovmf.tar.gz | gunzip | tar -xf - -C vendor

vendor/limine/limine:
	git submodule update --init vendor/limine
	$(MAKE) -Cvendor/limine CC="$(HOST_CC)" CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)" LIBS="$(HOST_LIBS)"

vendor/limine-protocol:
	git submodule update --init vendor/limine-protocol

vendor/uacpi:
	git submodule update --init vendor/uacpi
	git submodule update --init vendor/uacpi-bindings
