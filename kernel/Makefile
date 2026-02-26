.SUFFIXES:

include ../vars.mk

BINDIR = bin/$(TARGET_ARCH)
OBJDIR = obj/$(TARGET_ARCH)
RTLDIR = lib/fpc/$(FPCVERSION)/units/$(TARGET_ARCH)-embedded/rtl
UNITDIR = units/$(TARGET_ARCH)-embedded

UACPI_CFLAGS := -I../vendor/uacpi/include -DUACPI_USE_BUILTIN_STRING

override FPCFLAGS += -vehinw -vm4055,4056,6058

# uACPI source files
SRCS := $(addprefix uacpi/, $(notdir $(wildcard ../vendor/uacpi/source/*.c)))

# Kernel source files
SRCS += $(addprefix kernel/, $(notdir $(wildcard arch/$(TARGET_ARCH)/*.asm)))

ASM_SRCS := $(filter %.asm, $(SRCS))
C_SRCS   := $(filter %.c,   $(SRCS))
PSF_SRCS := $(filter %.psf, $(SRCS))

OBJS := $(addprefix $(OBJDIR)/, $(ASM_SRCS:.asm=.asm.o) $(C_SRCS:.c=.c.o))
DEPS := $(OBJS:.o=.d)

.PHONY: all
all: $(BINDIR)/kernel

.PHONY: clean
clean: fpmake
	./fpmake clean --cpu=$(TARGET_ARCH) --os=embedded
	rm -rf $(BINDIR) $(OBJDIR) $(RTLDIR)

.PHONY: distclean
distclean: fpmake
	./fpmake distclean
	rm -rf bin/ obj/ lib/

# Kernel binary
$(BINDIR)/kernel: compile $(OBJS) arch/scripts/$(TARGET_ARCH).lds
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LDFLAGS) -Tarch/scripts/$(TARGET_ARCH).lds -o$@ $(wildcard $(OBJS) $(UNITDIR)/*.o $(RTLDIR)/*.o)

.PHONY: compile
compile: fpmake
	./fpmake compile --cpu=$(TARGET_ARCH) --os=embedded --options="$(FPCFLAGS)" --searchpath=lib/fpc/$(FPCVERSION)/

fpmake: fpmake.pas
	$(HOST_FPC) $(HOST_FPCFLAGS) -o$@ $<

# Kernel *.asm files
$(OBJDIR)/kernel/%.asm.o: arch/$(TARGET_ARCH)/%.asm
	mkdir -p $(dir $@)
ifeq ($(TARGET_ARCH), x86_64)
	$(NASM) $(NASMFLAGS) -MD$(@:.o=.d) -MP -o$@ $<
else
	$(CC) $(CFLAGS) -MMD -MP -o$@ $<
endif

# uACPI *.c files
$(OBJDIR)/uacpi/%.c.o: ../vendor/uacpi/source/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(UACPI_CFLAGS) -MMD -MP -o$@ -c $<

-include $(DEPS)
