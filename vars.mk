DEBUG ?= 1

ROOTDIR ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OUTDIR ?= $(ROOTDIR)build/

ARCH ?= x86_64
ARCH_SRCDIR ?= $(ROOTDIR)arch/$(ARCH)/
ARCH_OUTDIR ?= $(OUTDIR)

RTL_SRCDIR ?= $(ROOTDIR)rtl/
RTL_OUTDIR ?= $(OUTDIR)rtl/

OVMFCODE ?= /usr/share/edk2/x64/OVMF_CODE.4m.fd
OVMFVARS ?= /usr/share/edk2/x64/OVMF_VARS.4m.fd

AS ?= $(ARCH)-elf-as
ASFLAGS ?=
ifeq ($(DEBUG), 1)
ASFLAGS += -g
endif
ifeq ($(ARCH), x86_64)
ASFLAGS += -mintel64
endif

FP ?= fpc
FPFLAGS ?= -Aelf -Cn -Fu$(OUTDIR) -Fu$(RTL_OUTDIR) -n -P$(ARCH) -Rintel -Sagic -Tlinux -vehinw
ifeq ($(DEBUG), 1)
FPFLAGS += -g -O-
else
FPFLAGS += -O2
endif

LD ?= $(ARCH)-elf-ld
LDFLAGS ?= -nostdlib -zmax-page-size=0x1000 -znoexecstack --gc-sections
ifeq ($(DEBUG), 1)
FPFLAGS +=
endif

QEMU ?= qemu-system-$(ARCH)
QEMUFLAGS ?= -cpu qemu64 -m 256M -net none
ifeq ($(DEBUG), 1)
QEMUFLAGS += -gdb tcp::1234 -S
endif
