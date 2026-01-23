include vars.mk

all: $(OUTDIR)/ristretto.img

kernel: krtl
	@make -Ckernel OUTDIR=$(OUTDIR)/$@ RTLDIR=$(OUTDIR)/$<

krtl:
	@make -Crtl OUTDIR=$(OUTDIR)/$@ KERNEL=1

urtl:
	@make -Crtl OUTDIR=$(OUTDIR)/$@ USER=1

run: $(OUTDIR)/ristretto.img
	@$(QEMU) $(QEMUFLAGS) \
		-drive format=raw,file=$< \
		-drive if=pflash,format=raw,unit=0,file=$(OVMFCODE),readonly=on \
		-drive if=pflash,format=raw,unit=1,file=$(OVMFVARS)

clean:
	@rm -rf $(OUTDIR)

$(OUTDIR)/kernel.elf: kernel

$(OUTDIR)/ristretto.img: kernel
	@dd if=/dev/zero of=$@ bs=512 count=81920 \
		&& mformat -i $@ -F :: \
		&& mmd -i $@ ::/EFI ::/EFI/BOOT ::/boot ::/boot/limine \
		&& mcopy -i $@ vendor/limine/BOOTX64.EFI ::/EFI/BOOT \
		&& mcopy -i $@ limine.conf ::/boot/limine \
		&& mcopy -i $@ $(OUTDIR)/kernel/kernel.elf ::/boot
