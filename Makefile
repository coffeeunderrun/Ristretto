include vars.mk

$(OUTDIR) $(RTL_OUTDIR):
	@mkdir -p $@

$(OUTDIR)kernel.elf: $(OUTDIR) $(RTL_OUTDIR)
	@make -Carch/$(ARCH)
	@make -Crtl
	@make -Ckernel

$(OUTDIR)ristretto.img: $(OUTDIR)kernel.elf
	@dd if=/dev/zero of=$@ bs=512 count=81920 \
		&& mformat -i $@ -F :: \
		&& mmd -i $@ ::/EFI ::/EFI/BOOT ::/boot ::/boot/limine \
		&& mcopy -i $@ vendor/limine/BOOTX64.EFI ::/EFI/BOOT \
		&& mcopy -i $@ limine.conf ::/boot/limine \
		&& mcopy -i $@ $^ ::/boot

run: $(OUTDIR)ristretto.img
	@$(QEMU) $(QEMUFLAGS) \
		-drive format=raw,file=$< \
		-drive if=pflash,format=raw,unit=0,file=$(OVMFCODE),readonly=on \
		-drive if=pflash,format=raw,unit=1,file=$(OVMFVARS)

all: $(OUTDIR)ristretto.img

clean:
	@rm -rf $(OUTDIR) $(RTL_OUTDIR)
