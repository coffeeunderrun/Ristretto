include vars.mk

$(OUTDIR)kernel.elf: rtl kernel

$(OUTDIR)ristretto.img: $(OUTDIR)kernel.elf
	@dd if=/dev/zero of=$@ bs=512 count=81920 \
		&& mformat -i $@ -F :: \
		&& mmd -i $@ ::/EFI ::/EFI/BOOT ::/boot ::/boot/limine \
		&& mcopy -i $@ vendor/limine/BOOTX64.EFI ::/EFI/BOOT \
		&& mcopy -i $@ limine.conf ::/boot/limine \
		&& mcopy -i $@ $^ ::/boot

$(OUTDIR) $(RTLDIR):
	@mkdir -p $@

run: $(OUTDIR)ristretto.img
	@$(QEMU) $(QEMUFLAGS) \
		-drive format=raw,file=$< \
		-drive if=pflash,format=raw,unit=0,file=$(OVMFCODE),readonly=on \
		-drive if=pflash,format=raw,unit=1,file=$(OVMFVARS)

rtl: $(RTLDIR)
	@make -Crtl

kernel: $(OUTDIR)
	@make -Ckernel

all: $(OUTDIR)ristretto.img

clean:
	@rm -rf $(OUTDIR) $(RTLDIR)
