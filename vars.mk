HOST_ARCH ?= x86_64
TARGET_ARCH ?= x86_64
IMAGENAME = ristretto

DEBUG = 1
USEGDB = 0

NASM = nasm
NASMFLAGS =
override NASMFLAGS += -felf64

CC = cc
CFLAGS = -pipe
override CFLAGS += -ffreestanding -fno-builtin -fno-pic -ffunction-sections -fdata-sections \
  -fomit-frame-pointer -fno-unwind-tables -fno-stack-protector -Wall -Wextra

LDFLAGS =
override LDFLAGS += -nostdlib -static -zmax-page-size=0x1000

override FPCFLAGS += -Cn -Cg-i-o-r-t- -Mobjfpc -n -Sagic
FPCVERSION = $(shell fpc -iW)

HOST_CC = cc
HOST_CFLAGS = -pipe

HOST_FPC = fpc
HOST_FPCFLAGS =

QEMU = qemu-system-$(TARGET_ARCH)
QEMUFLAGS = -m 128M -net none -serial mon:stdio

ifeq ($(DEBUG), 1)
  override NASMFLAGS += -gdwarf -O0
  override CFLAGS += -g -O0
  override FPCFLAGS += -gw3 -O- -Si-
  override HOST_CFLAGS += -g -O0
  override QEMUFLAGS += -d int -no-shutdown -no-reboot
else
  override NASMFLAGS += -Ox
  override CFLAGS += -O2 -DNDEBUG
  override LDFLAGS += -s
  override FPCFLAGS += -O2 -CX -XXs -dNDEBUG
  override HOST_CFLAGS += -O2
endif

ifeq ($(TARGET_ARCH), x86_64)
  override CFLAGS += -mcmodel=kernel -mabi=sysv -m64 -march=x86-64 -mno-red-zone \
    -mno-80387 -mno-mmx -mno-sse -mno-sse2
  override QEMUFLAGS += -M q35
endif

ifeq ($(USEGDB), 1)
  override QEMUFLAGS += -gdb tcp::1234 -S
else ifeq ($(TARGET_ARCH), $(HOST_ARCH))
  override QEMUFLAGS += -enable-kvm -cpu host
endif
