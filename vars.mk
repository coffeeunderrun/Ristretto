ROOTDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
BUILDDIR := $(ROOTDIR)/build/

OVMFCODE := /usr/share/edk2/x64/OVMF_CODE.4m.fd
OVMFVARS := /usr/share/edk2/x64/OVMF_VARS.4m.fd

AS := nasm
ASFLAGS := -felf64 -g

FP := fpc
FPFLAGS := -n -Aelf -Cn -Px86_64 -Rintel -Tlinux -g -O- -Fo$(BUILDDIR) -Fu$(BUILDDIR)

LD := x86_64-elf-ld
LDFLAGS := -Tlink.ld -zmax-page-size=0x1000 -znoexecstack --gc-sections

QEMU := qemu-system-x86_64
QEMUFLAGS := -cpu qemu64 -m 256M -net none -gdb tcp::1234 -S
