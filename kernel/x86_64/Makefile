include ../../vars.mk

SRCS := $(wildcard *.asm *.pas)

OBJS := $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(patsubst %.asm, %.asm.o, $(OBJS))
OBJS := $(addprefix $(OUTDIR), $(OBJS))

$(OUTDIR)$(ARCH).o: $(OBJS)
	$(LD) -r -o $@ $^

$(OUTDIR)%.asm.o: %.asm
	$(AS) $(ASFLAGS) -o$@ $<

$(OUTDIR)%.o: %.pas
	$(FP) $(FPFLAGS) -Fu../ -o$@ $<
