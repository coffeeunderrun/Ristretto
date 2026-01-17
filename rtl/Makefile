include ../vars.mk
include ../rules.mk

FPFLAGS += -Fiinc -Fi$(ARCH)

# Do NOT change the order of sources
SRCS := system.pas objpas.pas si_prc.pas fpintres.pas

OBJS := $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(addprefix $(RTLDIR), $(OBJS))

$(OUTDIR)rtl.o: $(OBJS)
	$(LD) -r -o $@ $^
