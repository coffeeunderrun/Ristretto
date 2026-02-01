.SUFFIXES:

include ../vars.mk

BINDIR = bin/$(ARCH)
OBJDIR = obj/$(ARCH)

# Tell compiler not to add code to check for IO, overflow, range, stack errors
override PCFLAGS += -Ci- -Co- -Cr- -Ct- -Mobjfpc -Fu$(OBJDIR)/rtl

RTL_PCFLAGS    := -Firtl/inc -Firtl/sysutils -Firtl/$(ARCH)
KERNEL_PCFLAGS := -Fi../vendor/limine-protocol -Fu$(OBJDIR)/kernel -Fu$(OBJDIR)/uacpi -Fu$(OBJDIR)/limine-protocol

UACPI_CFLAGS  := -I../vendor/uacpi/uacpi/include -DUACPI_BAREBONES_MODE -DUACPI_USE_BUILTIN_STRING
UACPI_PCFLAGS := -Fi../vendor/uacpi/inc

# RTL source files
SRCS := $(addprefix rtl/, system.pas objpas.pas sysconst.pas sysutils.pas si_prc.pas fpintres.pas)
# Limine Protocol source files
SRCS += $(addprefix limine-protocol/, $(notdir $(wildcard ../vendor/limine-protocol/*.pas)))
# uACPI source files
SRCS += $(addprefix uacpi/, $(notdir $(wildcard ../vendor/uacpi/*.pas ../vendor/uacpi/uacpi/source/*.c)))
# Kernel source files
SRCS += $(addprefix kernel/, $(notdir $(wildcard $(ARCH)/*.asm $(ARCH)/*.pas *.pas *.psf)))

ASFILES  := $(filter %.asm, $(SRCS))
PCFILES  := $(filter %.pas, $(SRCS))
CFILES   := $(filter %.c,   $(SRCS))
PSFFILES := $(filter %.psf, $(SRCS))

DEPS := $(addprefix $(OBJDIR)/, $(ASFILES:.asm=.asm.d) $(PCFILES:.pas=.d) $(CFILES:.c=.c.d))
OBJS := $(addprefix $(OBJDIR)/, $(ASFILES:.asm=.asm.o) $(PCFILES:.pas=.o) $(CFILES:.c=.c.o) $(PSFFILES:.psf=.psf.o))

.PHONY: all
all: $(BINDIR)/kernel

.PHONY: clean
clean:
	rm -rf bin/$(ARCH)/ obj/$(ARCH)/

.PHONY: distclean
distclean:
	rm -rf bin/ obj/

# Kernel binary
$(BINDIR)/kernel: $(OBJS) $(ARCH)/link.ld
	mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) -T$(ARCH)/link.ld -o$@ $(OBJS)

# RTL *.pas files
$(OBJDIR)/rtl/%.o: rtl/%.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) $(RTL_PCFLAGS) -FU$(dir $@) -o$@ $<

# Kernel *.pas files
$(OBJDIR)/kernel/%.o: %.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) $(KERNEL_PCFLAGS) -FU$(dir $@) -o$@ $<

# Kernel architecture *.pas files
$(OBJDIR)/kernel/%.o: $(ARCH)/%.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) $(KERNEL_PCFLAGS) -FU$(dir $@) -o$@ $<

# Kernel architecture *.asm files
$(OBJDIR)/kernel/%.asm.o: $(ARCH)/%.asm
	mkdir -p $(dir $@)
ifeq ($(ARCH), x86_64)
	$(NASM) $(NASMFLAGS) -MD$(@:.o=.d) -MP -o$@ $<
else
	$(AS) $(ASFLAGS) -MMD -MP -o$@ $<
endif

# Kernel *.psf files
$(OBJDIR)/kernel/%.psf.o: %.psf
	mkdir -p $(dir $@)
	$(LD) -r -bbinary -o$@ $<

# Limine Protocol *.pas files
$(OBJDIR)/limine-protocol/%.o: ../vendor/limine-protocol/%.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) -FU$(dir $@) -o$@ $<

# uACPI *.c files
$(OBJDIR)/uacpi/%.c.o: ../vendor/uacpi/uacpi/source/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(UACPI_CFLAGS) -MMD -MP -o$@ -c $<

# uACPI *.pas files
$(OBJDIR)/uacpi/%.o: ../vendor/uacpi/%.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) $(UACPI_PCFLAGS) -FU$(dir $@) -o$@ $<

# Dependencies
-include $(DEPS)
