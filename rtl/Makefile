include ../vars.mk
include ../rules.mk

FPFLAGS += -Fi$(RTL_SRCDIR) -Fi$(RTL_SRCDIR)inc -Fi$(RTL_SRCDIR)$(ARCH)

SRCS := system.pas fpintres.pas si_prc.pas

OBJS := $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(patsubst %.asm, %.asm.o, $(OBJS))
OBJS := $(addprefix $(RTL_OUTDIR), $(OBJS))

$(OUTDIR)rtl.o: $(OBJS)
	$(LD) -r -o $@ $^
