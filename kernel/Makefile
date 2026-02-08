.SUFFIXES:

include ../vars.mk

BINDIR = bin/$(TARGET_ARCH)
OBJDIR = obj/$(TARGET_ARCH)

# Tell compiler not to add code to check for IO, overflow, range, stack errors
override PCFLAGS += -Ci- -Co- -Cr- -Ct- -Mobjfpc -Fu$(OBJDIR)/rtl

RTL_PCFLAGS    := -Firtl/inc -Firtl/sysutils -Firtl/$(TARGET_ARCH)
KERNEL_PCFLAGS := -Fi../vendor/limine-protocol -Fi$(TARGET_ARCH)
KERNEL_PCFLAGS +=	-Fu$(OBJDIR)/kernel -Fu$(OBJDIR)/limine-protocol -Fu$(OBJDIR)/uacpi-bindings

UACPI_CFLAGS  := -I../vendor/uacpi/include -DUACPI_BAREBONES_MODE -DUACPI_USE_BUILTIN_STRING
UACPI_PCFLAGS := -Fi../vendor/uacpi-bindings/inc

# RTL source files
SRCS := $(addprefix rtl/, system.pas objpas.pas sysconst.pas sysutils.pas si_prc.pas fpintres.pas)
# Limine Protocol source files
SRCS += $(addprefix limine-protocol/, $(notdir $(wildcard ../vendor/limine-protocol/*.pas)))
# uACPI source files
SRCS += $(addprefix uacpi/, $(notdir $(wildcard ../vendor/uacpi/source/*.c)))
# uACPI bindings source files
SRCS += $(addprefix uacpi-bindings/, $(notdir $(wildcard ../vendor/uacpi-bindings/*.pas)))
# Kernel source files
SRCS += $(addprefix kernel/, $(notdir $(wildcard $(TARGET_ARCH)/*.asm $(TARGET_ARCH)/*.pas src/*.pas )))
# Kernel resource files
SRCS += $(addprefix kernel/, $(notdir $(wildcard res/*.psf)))

ASM_SRCS := $(filter %.asm, $(SRCS))
PAS_SRCS := $(filter %.pas, $(SRCS))
C_SRCS   := $(filter %.c,   $(SRCS))
PSF_SRCS := $(filter %.psf, $(SRCS))

DEPS := $(addprefix $(OBJDIR)/, $(ASM_SRCS:.asm=.asm.d) $(PAS_SRCS:.pas=.d) $(C_SRCS:.c=.c.d))
OBJS := $(addprefix $(OBJDIR)/, $(ASM_SRCS:.asm=.asm.o) $(PAS_SRCS:.pas=.o) $(C_SRCS:.c=.c.o) $(PSF_SRCS:.psf=.psf.o))

.PHONY: all
all: $(BINDIR)/kernel

.PHONY: clean
clean:
	rm -rf bin/$(TARGET_ARCH)/ obj/$(TARGET_ARCH)/

.PHONY: distclean
distclean:
	rm -rf bin/ obj/

# Kernel binary
$(BINDIR)/kernel: $(OBJS) $(TARGET_ARCH)/link.ld
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LDFLAGS) -T$(TARGET_ARCH)/link.ld -o$@ $(wildcard $(OBJS))

# RTL *.pas files
$(OBJDIR)/rtl/%.d: rtl/%.pas
	mkdir -p $(dir $@)
	$(PD) $(PDFLAGS) $(RTL_PCFLAGS) -Fu$(dir $@) -o$@ -t$(@:.d=.o) -Pe.o $<

$(OBJDIR)/rtl/%.o: rtl/%.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) $(RTL_PCFLAGS) -FU$(dir $@) -o$@ $<

# Kernel *.pas files
$(OBJDIR)/kernel/%.d: src/%.pas
	mkdir -p $(dir $@)
	$(PD) $(PDFLAGS) $(KERNEL_PCFLAGS) -Fu$(dir $<) -Fu$(TARGET_ARCH) -o$@ -t$(@:.d=.o) -Pe.o $<

$(OBJDIR)/kernel/%.o: src/%.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) $(KERNEL_PCFLAGS) -FU$(dir $@) -o$@ $<

# Kernel architecture *.pas files
$(OBJDIR)/kernel/%.d: $(TARGET_ARCH)/%.pas
	mkdir -p $(dir $@)
	$(PD) $(PDFLAGS) $(KERNEL_PCFLAGS) -Fu$(dir $<) -Fusrc -o$@ -t$(@:.d=.o) -Pe.o $<

$(OBJDIR)/kernel/%.o: $(TARGET_ARCH)/%.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) $(KERNEL_PCFLAGS) -FU$(dir $@) -o$@ $<

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

# Limine Protocol *.pas files
$(OBJDIR)/limine-protocol/%.d: ../vendor/limine-protocol/%.pas
	mkdir -p $(dir $@)
	$(PD) $(PDFLAGS) -FU$(dir $@) -o$@ -t$(@:.d=.o) -Pe.o $<

$(OBJDIR)/limine-protocol/%.o: ../vendor/limine-protocol/%.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) -FU$(dir $@) -o$@ $<

# uACPI *.c files
$(OBJDIR)/uacpi/%.c.o: ../vendor/uacpi/source/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(UACPI_CFLAGS) -MMD -MP -o$@ -c $<

# uACPI bindings *.pas files
$(OBJDIR)/uacpi-bindings/%.d: ../vendor/uacpi-bindings/%.pas
	mkdir -p $(dir $@)
	$(PD) $(PDFLAGS) $(UACPI_PCFLAGS) -FU$(dir $@) -o$@ -t$(@:.d=.o) -Pe.o $<

$(OBJDIR)/uacpi-bindings/%.o: ../vendor/uacpi-bindings/%.pas
	mkdir -p $(dir $@)
	$(PC) $(PCFLAGS) $(UACPI_PCFLAGS) -FU$(dir $@) -o$@ $<

# Dependencies
-include $(DEPS)
