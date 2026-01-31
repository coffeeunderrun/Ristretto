ARCH = x86_64
DEBUG = 1
IMAGENAME = ristretto

AS = as
ASFLAGS =

NASM = nasm
NASMFLAGS =
override NASMFLAGS += -felf64

CC = cc
CFLAGS = -pipe
override CFLAGS += -ffreestanding -fno-builtin -fno-pic -ffunction-sections -fdata-sections \
	-fomit-frame-pointer -fno-unwind-tables -fno-stack-protector -Wall -Wextra

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
override CFLAGS += -g -O0
override PCFLAGS += -g -O- -Si-
override HOST_CFLAGS += -g -O0
override QEMUFLAGS += -gdb tcp::1234 -S -d int -no-shutdown -no-reboot
else
override ASFLAGS += -O2
override NASMFLAGS += -Ox
override CFLAGS += -O2 -DNDEBUG
override LDFLAGS += -s --gc-sections
override PCFLAGS += -O2 -dNDEBUG
override HOST_CFLAGS += -O2
endif

ifeq ($(ARCH), x86_64)
override CFLAGS += -mcmodel=kernel -mabi=sysv -m64 -march=x86-64 -mno-red-zone -mno-80387 -mno-mmx -mno-sse -mno-sse2
override PCFLAGS += -Rintel
override QEMUFLAGS += -M q35
endif
