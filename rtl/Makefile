include ../vars.mk
include ../rules.mk

FPFLAGS += -Fiinc -Fi$(ARCH)

SRCS := $(wildcard *.pas)

OBJS := $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(addprefix $(RTLDIR), $(OBJS))

$(OUTDIR)rtl.o: $(OBJS)
	$(LD) -r -o $@ $^
