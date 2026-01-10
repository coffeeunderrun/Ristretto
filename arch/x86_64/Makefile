include ../../vars.mk
include ../../rules.mk

SRCS := entry.asm

OBJS := $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(patsubst %.asm, %.asm.o, $(OBJS))
OBJS := $(addprefix $(OUTDIR), $(OBJS))

$(OUTDIR)arch.o: $(OBJS)
	$(LD) -r -o $@ $^
