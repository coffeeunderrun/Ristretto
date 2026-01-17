$(OUTDIR)%.asm.o: %.asm
	$(AS) $(ASFLAGS) -o$@ $<

$(OUTDIR)%.o: %.pas
	$(FP) $(FPFLAGS) -o$@ $<

$(RTLDIR)%.o: objpas/%.pas
	$(FP) $(FPFLAGS) -o$@ $<

$(RTLDIR)%.o: ristretto/%.pas
	$(FP) $(FPFLAGS) -o$@ $<
