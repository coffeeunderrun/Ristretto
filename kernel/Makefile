include ../vars.mk
include ../rules.mk

LDFLAGS += -T$(ARCH_SRCDIR)link.ld

SRCS := kernel.pas limine.pas log.pas framebuffer.pas terminal.pas
RSRC := kernel.psf
OBJS := arch.o rtl.o

OBJS += $(patsubst %.pas, %.o, $(SRCS))
OBJS += $(patsubst %.psf, %.psf.o, $(RSRC))
OBJS := $(addprefix $(OUTDIR), $(OBJS))

$(OUTDIR)kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -o$@ $^

$(OUTDIR)%.psf.o: %.psf
	$(LD) -r -bbinary -o$@ $<
