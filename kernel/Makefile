.SUFFIXES:

include ../vars.mk

BINDIR = bin/$(TARGET_ARCH)
OBJDIR = obj/$(TARGET_ARCH)
UNITDIR = units/$(TARGET_ARCH)-linux
RTLUNITDIR = rtl/units/$(TARGET_ARCH)-linux

UACPI_CFLAGS := -I../vendor/uacpi/include -DUACPI_BAREBONES_MODE -DUACPI_USE_BUILTIN_STRING

# uACPI source files
SRCS := $(addprefix uacpi/, $(notdir $(wildcard ../vendor/uacpi/source/*.c)))

# Kernel source files
SRCS += $(addprefix kernel/, $(notdir $(wildcard $(TARGET_ARCH)/*.asm)))

# Kernel resource files
SRCS += $(addprefix kernel/, $(notdir $(wildcard res/*.psf)))

ASM_SRCS := $(filter %.asm, $(SRCS))
C_SRCS   := $(filter %.c,   $(SRCS))
PSF_SRCS := $(filter %.psf, $(SRCS))

DEPS := $(addprefix $(OBJDIR)/, $(ASM_SRCS:.asm=.asm.d) $(C_SRCS:.c=.c.d))
OBJS := $(addprefix $(OBJDIR)/, $(ASM_SRCS:.asm=.asm.o) $(C_SRCS:.c=.c.o) $(PSF_SRCS:.psf=.psf.o))

.PHONY: all
all: $(BINDIR)/kernel

.PHONY: clean
clean:
	rm -rf $(BINDIR) $(OBJDIR) $(UNITDIR) $(RTLUNITDIR)
	rm -rf lib/fpc/$(FPCVERSION)/units/$(TARGET_ARCH)-linux

.PHONY: distclean
distclean:
	rm -rf bin/ lib/ obj/ units/ rtl/units
	rm -f fpmake *.o *.fpm rtl/fpmake rtl/*.o rtl/*.fpm

# Kernel binary
$(BINDIR)/kernel: rtlobjs kernelobjs $(OBJS) $(TARGET_ARCH)/link.ld
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LDFLAGS) -T$(TARGET_ARCH)/link.ld -o$@ \
		$(wildcard $(OBJS) $(UNITDIR)/*.o $(RTLUNITDIR)/*.o)

.PHONY: rtlobjs
rtlobjs: rtl/fpmake
	./rtl/fpmake install --prefix=. --options="$(FPCFLAGS)"

rtl/fpmake: rtl/fpmake.pas
	$(HOST_FPC) $(HOST_FPCFLAGS) -o$@ $<

.PHONY: kernelobjs
kernelobjs: fpmake
	./fpmake compile --searchpath=lib/fpc/$(FPCVERSION)/ --options="$(FPCFLAGS)"

fpmake: fpmake.pas
	$(HOST_FPC) $(HOST_FPCFLAGS) -o$@ $<

# Kernel architecture *.asm files
$(OBJDIR)/kernel/%.asm.o: $(TARGET_ARCH)/%.asm
	mkdir -p $(dir $@)
ifeq ($(TARGET_ARCH), x86_64)
	$(NASM) $(NASMFLAGS) -MD$(@:.o=.d) -MP -o$@ $<
else
	$(CC) $(CFLAGS) -MMD -MP -o$@ $<
endif

# Kernel *.psf files
$(OBJDIR)/kernel/%.psf.o: res/%.psf
	mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) -Wl,-r -Wl,-b,binary -Wl,$< -o$@

# uACPI *.c files
$(OBJDIR)/uacpi/%.c.o: ../vendor/uacpi/source/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(UACPI_CFLAGS) -MMD -MP -o$@ -c $<

# Dependencies
-include $(DEPS)
