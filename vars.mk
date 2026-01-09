ARCH ?= x86_64

DEBUG ?= 1

ROOTDIR ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
ARCHDIR ?= $(ROOTDIR)arch/$(ARCH)/
BUILDDIR ?= $(ROOTDIR)build/

OVMFCODE ?= /usr/share/edk2/x64/OVMF_CODE.4m.fd
OVMFVARS ?= /usr/share/edk2/x64/OVMF_VARS.4m.fd

AR ?= $(ARCH)-elf-ar
ARFLAGS ?=

AS ?= nasm
ASFLAGS ?= -felf64
ifeq ($(DEBUG), 1)
ASFLAGS += -g
endif

FP ?= fpc
FPFLAGS ?= -Aelf -Cn -Fu$(BUILDDIR) -n -P$(ARCH) -Rintel -Sagic -Tlinux -vehinw
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
