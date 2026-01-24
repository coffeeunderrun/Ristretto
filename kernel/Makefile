include ../vars.mk

# FPC does not provide a method for generating dependency files and PPDEP struggles with directives.
# For now all INC files, within the same folder as a PAS file, will be considered a dependency.

FPFLAGS += -FE$(OUTDIR) -FU$(OUTDIR)

# Do NOT change the order of the RTL objects
RTLOBJS := system objpas si_prc fpintres
RTLOBJS := $(patsubst %, $(OUTDIR)/%.o, $(RTLOBJS))

ASMOBJS := $(notdir $(wildcard $(ARCH)/*.asm))
ASMOBJS := $(patsubst %.asm, $(OUTDIR)/%.asm.o, $(ASMOBJS))

PASOBJS := $(notdir $(wildcard *.pas $(ARCH)/*.pas))
PASOBJS := $(patsubst %.pas, $(OUTDIR)/%.o, $(PASOBJS))

PSFOBJS := $(notdir $(wildcard *.psf))
PSFOBJS := $(patsubst %.psf, $(OUTDIR)/%.psf.o, $(PSFOBJS))

all: $(OUTDIR)/kernel.elf

$(OUTDIR)/kernel.elf: $(RTLOBJS) $(ASMOBJS) $(PASOBJS) $(PSFOBJS)
	$(LD) $(LDFLAGS) -T$(ARCH)/link.ld -o$@ $^

$(OUTDIR)/system.o: rtl/system.pas $(wildcard rtl/*.inc rtl/$(ARCH)/*.inc)
	$(FP) $(FPFLAGS) -Firtl/$(ARCH) -Us -Sf- -o$@ $<

$(OUTDIR)/%.o: rtl/%.pas $(wildcard rtl/*.inc rtl/$(ARCH)/*.inc)
	$(FP) $(FPFLAGS) -Firtl/$(ARCH) -o$@ $<

$(OUTDIR)/%.o: %.pas $(RTLOBJS) $(wildcard *.inc)
	$(FP) $(FPFLAGS) -Furtl -Fu$(ARCH) -o$@ $<

$(OUTDIR)/%.o: $(ARCH)/%.pas $(RTLOBJS) $(wildcard $(ARCH)/*.inc)
	$(FP) $(FPFLAGS) -Furtl -o$@ $<

$(OUTDIR)/%.asm.o: $(ARCH)/%.asm
	$(AS) $(ASFLAGS) -o$@ $<

$(OUTDIR)/%.psf.o: %.psf
	$(LD) -r -bbinary -o$@ $<
