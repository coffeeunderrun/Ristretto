include vars.mk

all: kernel

clean:
	@rm -rf $(OUTDIR)

# Kernel uses its own slim RTL
kernel:
	@mkdir -p $(OUTDIR)/$@
	@make -Ckernel OUTDIR=$(OUTDIR)/$@

# RTL for userspace
rtl:
	@mkdir -p $(OUTDIR)/$@
	@make -Crtl OUTDIR=$(OUTDIR)/$@

run: $(OUTDIR)/ristretto.img
	@$(QEMU) $(QEMUFLAGS) \
		-drive format=raw,file=$< \
		-drive if=pflash,format=raw,unit=0,file=$(OVMFCODE),readonly=on \
		-drive if=pflash,format=raw,unit=1,file=$(OVMFVARS)

$(OUTDIR)/ristretto.img: kernel
	@dd if=/dev/zero of=$@ bs=512 count=81920 \
		&& mformat -i $@ -F :: \
		&& mmd -i $@ ::/EFI ::/EFI/BOOT ::/boot ::/boot/limine \
		&& mcopy -i $@ vendor/limine/BOOTX64.EFI ::/EFI/BOOT \
		&& mcopy -i $@ limine.conf ::/boot/limine \
		&& mcopy -i $@ $(OUTDIR)/kernel/kernel.elf ::/boot

.PHONY: all clean kernel rtl run
