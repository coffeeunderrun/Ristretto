$(OUTDIR)%.asm.o: %.asm
	$(AS) $(ASFLAGS) -o$@ $<

$(OUTDIR)%.o: %.pas
	$(FP) $(FPFLAGS) -o$@ $<

$(RTL_OUTDIR)%.asm.o: %.asm
	$(AS) $(ASFLAGS) -o$@ $<

$(RTL_OUTDIR)%.o: %.pas
	$(FP) $(FPFLAGS) -o$@ $<
