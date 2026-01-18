include ../vars.mk

# Do NOT change the order of objects
OBJS := system.o objpas.o si_prc.o fpintres.o
OBJS := $(addprefix $(RTLDIR), $(OBJS))

$(OUTDIR)rtl.o: $(OBJS)
	$(LD) -r -o $@ $^

$(RTLDIR)system.o: ristretto/system.pas
	$(FP) $(FPFLAGS) -Fiinc -Firistretto -Fi$(ARCH) -Us -Sf- -o$@ $<

$(RTLDIR)objpas.o: objpas/objpas.pas
	$(FP) $(FPFLAGS) -Fiinc -Fi$(ARCH) -o$@ $<

$(RTLDIR)si_prc.o: ristretto/si_prc.pas
	$(FP) $(FPFLAGS) -o$@ $<

$(RTLDIR)fpintres.o: ristretto/fpintres.pas
	$(FP) $(FPFLAGS) -o$@ $<
