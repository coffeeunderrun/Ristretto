$(OUTDIR)%.asm.o: %.asm
	$(AS) $(ASFLAGS) -o$@ $<

$(OUTDIR)%.o: %.pas
	$(FP) $(FPFLAGS) -o$@ $<

$(RTLDIR)%.asm.o: %.asm
	$(AS) $(ASFLAGS) -o$@ $<

$(RTLDIR)%.o: %.pas
	$(FP) $(FPFLAGS) -o$@ $<
