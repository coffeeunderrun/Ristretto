include ../vars.mk

ifeq ($(KERNEL), 1)
SRCDIR := kernel
ARCHDIR := kernel/$(ARCH)
else
SRCDIR := ristretto
ARCHDIR := $(ARCH)
endif

# Do NOT change the order of objects
OBJS := system.o objpas.o si_prc.o fpintres.o
OBJS := $(addprefix $(OUTDIR)/, $(OBJS))

all: | $(OUTDIR)
all: $(OUTDIR)/rtl.o

$(OUTDIR):
	@mkdir -p $@

$(OUTDIR)/rtl.o: $(OBJS)
	$(LD) -r -o $@ $^

$(OUTDIR)/system.o: $(SRCDIR)/system.pas $(wildcard $(SRCDIR)/*.inc)
	$(FP) $(FPFLAGS) -Fiinc -Fi$(SRCDIR) -Fi$(ARCHDIR) -Us -Sf- -o$@ $<

$(OUTDIR)/objpas.o: objpas/objpas.pas $(wildcard objpas/*.inc)
	$(FP) $(FPFLAGS) -Fiinc -Fi$(ARCHDIR) -o$@ $<

$(OUTDIR)/si_prc.o: $(SRCDIR)/si_prc.pas $(wildcard $(SRCDIR)/*.inc)
	$(FP) $(FPFLAGS) -o$@ $<

$(OUTDIR)/fpintres.o: $(SRCDIR)/fpintres.pas $(wildcard $(SRCDIR)/*.inc)
	$(FP) $(FPFLAGS) -o$@ $<
