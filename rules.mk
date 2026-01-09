$(BUILDDIR)%.asm.o: %.asm
	$(AS) $(ASFLAGS) -o$@ $<

$(BUILDDIR)%.o: %.pas
	$(FP) $(FPFLAGS) -o$@ $<

$(BUILDDIR)%.o: %.pp
	$(FP) $(FPFLAGS) -o$@ $<
