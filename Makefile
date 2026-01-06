AS := nasm
ASFLAGS := -felf64
ASFLAGS += -g

FP := fpc
FPFLAGS := -n -Aelf -Cn -Px86_64 -Rintel -Tlinux -g -O-

LD := x86_64-elf-ld
LDFLAGS := -Tlink.ld -zmax-page-size=0x1000 -znoexecstack --gc-sections

BUILDDIR := ./build

SRCS := kernel.pas framebuffer.pas limine.pas system.pas
OBJS := $(patsubst %.pas, $(BUILDDIR)/%.o, $(SRCS))
OBJS := $(patsubst %.asm, $(BUILDDIR)/%.asm.o, $(OBJS))

$(BUILDDIR)/kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -o$@ $^

$(BUILDDIR)/%.asm.o: %.asm
	@mkdir -p $(BUILDDIR)
	$(AS) $(ASFLAGS) -o$@ $<

$(BUILDDIR)/%.o: %.pas
	@mkdir -p $(BUILDDIR)
	$(FP) $(FPFLAGS) -o$@ $<

$(BUILDDIR)/ristretto.img: $(BUILDDIR)/kernel.elf
	@dd if=/dev/zero of=$@ bs=512 count=81920 \
		&& mformat -i $@ -F :: \
		&& mmd -i $@ ::/EFI ::/EFI/BOOT ::/boot ::/boot/limine \
		&& mcopy -i $@ vendor/limine/BOOTX64.EFI ::/EFI/BOOT \
		&& mcopy -i $@ limine.conf ::/boot/limine \
		&& mcopy -i $@ $^ ::/boot

run: $(BUILDDIR)/ristretto.img
	@qemu-system-x86_64 \
		-cpu qemu64 -m 256M -net none -gdb tcp::1234 -S \
		-drive format=raw,file=$< \
		-drive if=pflash,format=raw,unit=0,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd,readonly=on \
		-drive if=pflash,format=raw,unit=1,file=/usr/share/edk2/x64/OVMF_VARS.4m.fd

all: $(BUILDDIR)/ristretto.img

clean:
	@rm -rf $(BUILDDIR)
