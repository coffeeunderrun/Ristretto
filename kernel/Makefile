include ../vars.mk

# FPC does not provide a method for generating dependency files and PPDEP struggles with directives.
# For now, all INC files will be considered a dependency.

# Do NOT add code to check for IO, overflow, range, stack errors
FPFLAGS += -Ci-o-r-t- -Mobjfpc -FE$(OUTDIR) -FU$(OUTDIR)

# Do NOT change the order of the RTL objects
RTLOBJS := system objpas sysconst sysutils si_prc fpintres
RTLOBJS := $(patsubst %, $(OUTDIR)/%.o, $(RTLOBJS))

ASMOBJS := $(notdir $(wildcard $(ARCH)/*.asm))
ASMOBJS := $(patsubst %.asm, $(OUTDIR)/%.asm.o, $(ASMOBJS))

PASOBJS := $(notdir $(wildcard *.pas $(ARCH)/*.pas))
PASOBJS := $(patsubst %.pas, $(OUTDIR)/%.o, $(PASOBJS))

PSFOBJS := $(notdir $(wildcard *.psf))
PSFOBJS := $(patsubst %.psf, $(OUTDIR)/%.psf.o, $(PSFOBJS))

all: $(OUTDIR)/kernel.elf

$(OUTDIR)/kernel.elf: $(RTLOBJS) $(ASMOBJS) $(PASOBJS) $(PSFOBJS)
	$(LD) $(LDFLAGS) -T$(ARCH)/link.ld -o$@ $(wildcard $^)

# RTL unit: system
$(OUTDIR)/system.o: rtl/system.pas $(wildcard rtl/*.inc rtl/inc/*.inc rtl/$(ARCH)/*.inc)
	$(FP) $(FPFLAGS) -Firtl/inc -Firtl/$(ARCH) -Us -Sf- -o$@ $<

# RTL unit: sysutils
$(OUTDIR)/sysutils.o: rtl/sysutils.pas $(wildcard rtl/*.inc rtl/sysutils/*.inc)
	$(FP) $(FPFLAGS) -Firtl/sysutils -o$@ $<

# RTL units: objpas si_prc fpintres
$(OUTDIR)/%.o: rtl/%.pas $(wildcard rtl/*.inc)
	$(FP) $(FPFLAGS) -o$@ $<

# Kernel units
$(OUTDIR)/%.o: %.pas $(RTLOBJS) $(wildcard *.inc)
	$(FP) $(FPFLAGS) -Furtl -Fu$(ARCH) -o$@ $<

# Kerner arch-specific units
$(OUTDIR)/%.o: $(ARCH)/%.pas $(RTLOBJS) $(wildcard $(ARCH)/*.inc)
	$(FP) $(FPFLAGS) -Furtl -o$@ $<

# Kerner arch-specific asm
$(OUTDIR)/%.asm.o: $(ARCH)/%.asm
	$(AS) $(ASFLAGS) -o$@ $<

# Fonts
$(OUTDIR)/%.psf.o: %.psf
	$(LD) -r -bbinary -o$@ $<
