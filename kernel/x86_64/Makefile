include ../../vars.mk
include ../../rules.mk

FPFLAGS += -Fu../

SRCS := $(wildcard *.asm *.pas)

OBJS := $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(patsubst %.asm, %.asm.o, $(OBJS))
OBJS := $(addprefix $(OUTDIR), $(OBJS))

$(OUTDIR)arch.o: $(OBJS)
	$(LD) -r -o $@ $^
