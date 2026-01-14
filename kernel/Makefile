include ../vars.mk
include ../rules.mk

FPFLAGS += -Fi$(ARCH)
LDFLAGS += -T$(ARCH)/link.ld

SRCS := $(wildcard *.pas)
RSRC := kernel.psf
OBJS := arch.o rtl.o

OBJS += $(patsubst %.pas, %.o, $(SRCS))
OBJS += $(patsubst %.psf, %.psf.o, $(RSRC))
OBJS := $(addprefix $(OUTDIR), $(OBJS))

$(OUTDIR)kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -o$@ $^

$(OUTDIR)%.psf.o: %.psf
	$(LD) -r -bbinary -o$@ $<

$(OUTDIR)arch.o:
	@make -C$(ARCH)
