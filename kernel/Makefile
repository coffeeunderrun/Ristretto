include ../vars.mk
include ../rules.mk

SRCS := kernel.pas limine.pas framebuffer.pas
OBJS := system.o

OBJS += $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(patsubst %.asm, %.asm.o, $(OBJS))
OBJS := $(addprefix $(BUILDDIR), $(OBJS))

$(BUILDDIR)kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -o$@ $^

all:
	$(BUILDDIR)kernel.elf
