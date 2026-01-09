include ../../vars.mk
include ../../rules.mk

SRCS := entry.asm
OBJS := $(patsubst %.asm, %.asm.o, $(SRCS))
OBJS := $(addprefix $(BUILDDIR), $(OBJS))

$(BUILDDIR)arch.o: $(OBJS)
	$(AR) $(ARFLAGS) $@ $^
