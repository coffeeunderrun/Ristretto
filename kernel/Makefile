include ../vars.mk
include ../rules.mk

SRCS := kernel.pas limine.pas framebuffer.pas terminal.pas
OBJS := system.o
RESOBJS := kernel.psf.o

OBJS += $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(patsubst %.asm, %.asm.o, $(OBJS))
OBJS := $(addprefix $(BUILDDIR), $(OBJS))

$(BUILDDIR)kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -o$@ $^ $(RESOBJS)

all:
	$(BUILDDIR)kernel.elf
