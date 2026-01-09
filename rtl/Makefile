include ../vars.mk
include ../rules.mk

SRCS := system.pas fpintres.pas si_prc.pas

OBJS := $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(patsubst %.asm, %.asm.o, $(OBJS))
OBJS := $(addprefix $(BUILDDIR), $(OBJS))

all: $(OBJS)
