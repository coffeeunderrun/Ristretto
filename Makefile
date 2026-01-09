include vars.mk

$(BUILDDIR):
	@mkdir -p $@

$(BUILDDIR)kernel.elf: $(BUILDDIR)
	@make -Carch/$(ARCH)
	@make -Crtl
	@make -Ckernel

$(BUILDDIR)ristretto.img: $(BUILDDIR)kernel.elf
	@dd if=/dev/zero of=$@ bs=512 count=81920 \
		&& mformat -i $@ -F :: \
		&& mmd -i $@ ::/EFI ::/EFI/BOOT ::/boot ::/boot/limine \
		&& mcopy -i $@ vendor/limine/BOOTX64.EFI ::/EFI/BOOT \
		&& mcopy -i $@ limine.conf ::/boot/limine \
		&& mcopy -i $@ $^ ::/boot

run: $(BUILDDIR)ristretto.img
	@$(QEMU) $(QEMUFLAGS) \
		-drive format=raw,file=$< \
		-drive if=pflash,format=raw,unit=0,file=$(OVMFCODE),readonly=on \
		-drive if=pflash,format=raw,unit=1,file=$(OVMFVARS)

all: $(BUILDDIR)ristretto.img

clean:
	@rm -rf $(BUILDDIR)
