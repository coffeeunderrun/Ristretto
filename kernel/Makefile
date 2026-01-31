.SUFFIXES:

include ../vars.mk

BINDIR = bin/$(ARCH)
OBJDIR = obj/$(ARCH)

# FPC does not provide a method for generating dependency files and PPDEP struggles with directives.
# For now, all INC files will be considered a dependency.

# Do NOT add code to check for IO, overflow, range, stack errors
override PCFLAGS += -Ci- -Co- -Cr- -Ct- -Mobjfpc -FE$(BINDIR) -FU$(OBJDIR)

# Do NOT change the order of the RTL objects
RTLOBJS := system objpas sysconst sysutils si_prc fpintres
RTLOBJS := $(patsubst %, $(OBJDIR)/%.o, $(RTLOBJS))

ASMOBJS := $(notdir $(wildcard $(ARCH)/*.asm))
ASMOBJS := $(patsubst %.asm, $(OBJDIR)/%.asm.o, $(ASMOBJS))

PASOBJS := $(notdir $(wildcard *.pas $(ARCH)/*.pas))
PASOBJS := $(patsubst %.pas, $(OBJDIR)/%.o, $(PASOBJS))

PSFOBJS := $(notdir $(wildcard *.psf))
PSFOBJS := $(patsubst %.psf, $(OBJDIR)/%.psf.o, $(PSFOBJS))

.PHONY: all
all: $(BINDIR)/kernel.elf

.PHONY: clean
clean:
	rm -rf $(BINDIR) $(OBJDIR)

.PHONY: distclean
distclean:
	rm -rf bin/ obj/

$(BINDIR)/kernel.elf: $(RTLOBJS) $(ASMOBJS) $(PASOBJS) $(PSFOBJS)
	mkdir -p $(BINDIR)
	$(LD) $(LDFLAGS) -T$(ARCH)/link.ld -o$@ $(wildcard $^)

# RTL unit: system
$(OBJDIR)/system.o: rtl/system.pas $(wildcard rtl/*.inc rtl/inc/*.inc rtl/$(ARCH)/*.inc)
	mkdir -p $(OBJDIR)
	$(PC) $(PCFLAGS) -Firtl/inc -Firtl/$(ARCH) -Us -Sf- -o$@ $<

# RTL unit: sysutils
$(OBJDIR)/sysutils.o: rtl/sysutils.pas $(wildcard rtl/*.inc rtl/sysutils/*.inc)
	mkdir -p $(OBJDIR)
	$(PC) $(PCFLAGS) -Firtl/sysutils -o$@ $<

# RTL units: objpas si_prc fpintres
$(OBJDIR)/%.o: rtl/%.pas $(wildcard rtl/*.inc)
	mkdir -p $(OBJDIR)
	$(PC) $(PCFLAGS) -o$@ $<

# Kernel units
$(OBJDIR)/%.o: %.pas $(RTLOBJS) $(wildcard *.inc)
	mkdir -p $(OBJDIR)
	$(PC) $(PCFLAGS) -Furtl -Fu$(ARCH) -o$@ $<

# Kerner arch-specific units
$(OBJDIR)/%.o: $(ARCH)/%.pas $(RTLOBJS) $(wildcard $(ARCH)/*.inc) arch.inc
	mkdir -p $(OBJDIR)
	$(PC) $(PCFLAGS) -Furtl -o$@ $<

# Kerner arch-specific asm
$(OBJDIR)/%.asm.o: $(ARCH)/%.asm
	mkdir -p $(OBJDIR)
ifeq ($(ARCH), x86_64)
	$(NASM) $(NASMFLAGS) -o$@ $<
else
	$(AS) $(ASFLAGS) -o$@ $<
endif

# Fonts
$(OBJDIR)/%.psf.o: %.psf
	mkdir -p $(OBJDIR)
	$(LD) -r -bbinary -o$@ $<
