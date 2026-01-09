include ../vars.mk
include ../rules.mk

LDFLAGS += -T$(ARCHDIR)link.ld

SRCS := kernel.pas limine.pas log.pas framebuffer.pas terminal.pas
RSRC := kernel.psf
OBJS := system.o arch.o

OBJS += $(patsubst %.pas, %.o, $(SRCS))
OBJS += $(patsubst %.psf, %.psf.o, $(RSRC))
OBJS := $(addprefix $(BUILDDIR), $(OBJS))

$(BUILDDIR)kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -o$@ $^

$(BUILDDIR)%.psf.o: %.psf
	$(LD) -r -bbinary -o$@ $<

all:
	$(BUILDDIR)kernel.elf
