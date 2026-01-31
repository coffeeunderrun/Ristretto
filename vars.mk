ARCH = x86_64
DEBUG = 1
IMAGENAME = ristretto

AS = as
ASFLAGS =

NASM = nasm
NASMFLAGS =
override NASMFLAGS += -felf64

LD = ld
LDFLAGS =
override LDFLAGS += -nostdlib -static -zmax-page-size=0x1000

PC = fpc
PCFLAGS = -ap -vehinw
override PCFLAGS += -Aelf -Cn -n -P$(ARCH) -Sagic -Tlinux -uLINUX -uUNIX

HOST_CC = cc
HOST_CFLAGS = -pipe

QEMU = qemu-system-$(ARCH)
QEMUFLAGS = -m 256M -net none -monitor stdio

ifeq ($(DEBUG), 1)
override ASFLAGS += -g -O0
override NASMFLAGS += -gdwarf -O0
override PCFLAGS += -g -O- -Si-
override HOST_CFLAGS += -g -O0
override QEMUFLAGS += -gdb tcp::1234 -S -d int -no-shutdown -no-reboot
else
override ASFLAGS += -O2
override NASMFLAGS += -Ox
override LDFLAGS += -s --gc-sections
override PCFLAGS += -O2 -dNDEBUG
override HOST_CFLAGS += -O2
endif

ifeq ($(ARCH), x86_64)
override PCFLAGS += -Rintel
override QEMUFLAGS += -M q35
endif
