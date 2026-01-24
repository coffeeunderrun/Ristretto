ARCH ?= x86_64
DEBUG ?= 1

ROOTDIR ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OUTDIR ?= $(ROOTDIR)/build

OVMFCODE ?= /usr/share/edk2/x64/OVMF_CODE.4m.fd
OVMFVARS ?= /usr/share/edk2/x64/OVMF_VARS.4m.fd

AS ?= as
ASFLAGS ?=

FP ?= fpc
FPFLAGS ?= -Aelf -Cn -n -P$(ARCH) -Sagic -Tlinux -uLINUX -uUNIX -vehinw

LD ?= ld
LDFLAGS ?= -nostdlib -zmax-page-size=0x1000 -znoexecstack --gc-sections

QEMU ?= qemu-system-$(ARCH)
QEMUFLAGS ?= -cpu qemu64 -m 256M -net none -monitor stdio

ifeq ($(DEBUG), 1)
ASFLAGS += -g -O0
FPFLAGS += -g -O- -Si-
QEMUFLAGS += -gdb tcp::1234 -S -d int -no-shutdown -no-reboot
else
ASFLAGS += -O2 -g
FPFLAGS += -O2 -dNDEBUG
endif

ifeq ($(ARCH), x86_64)
ASFLAGS += -mintel64 -mnaked-reg
endif
