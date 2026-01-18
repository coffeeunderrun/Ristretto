ARCH ?= x86_64
DEBUG ?= 1

ROOTDIR ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OUTDIR ?= $(ROOTDIR)build/
RTLDIR ?= $(OUTDIR)rtl/

OVMFCODE ?= /usr/share/edk2/x64/OVMF_CODE.4m.fd
OVMFVARS ?= /usr/share/edk2/x64/OVMF_VARS.4m.fd

# Assembler
AS ?= as
ASFLAGS ?=
ifeq ($(DEBUG), 1)
ASFLAGS += -g
endif
ifeq ($(ARCH), x86_64)
ASFLAGS += -mintel64 -mnaked-reg
endif

# Compiler (Pascal)
FP ?= fpc
FPFLAGS ?= -Aelf -Cn -Fu$(RTLDIR) -n -P$(ARCH) -Rintel -Sagic -Tlinux -vehinw
ifeq ($(DEBUG), 1)
FPFLAGS += -g -O-
else
FPFLAGS += -O2 -dNDEBUG
endif

# Linker
LD ?= ld
LDFLAGS ?= -nostdlib -zmax-page-size=0x1000 -znoexecstack --gc-sections
ifeq ($(DEBUG), 1)
FPFLAGS +=
endif

QEMU ?= qemu-system-$(ARCH)
QEMUFLAGS ?= -cpu qemu64 -m 256M -net none -d int -no-shutdown -no-reboot -monitor stdio
ifeq ($(DEBUG), 1)
QEMUFLAGS += -gdb tcp::1234 -S
endif
