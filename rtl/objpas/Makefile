include ../../vars.mk
include ../../rules.mk

SRCS := $(wildcard *.pas)

OBJS := $(patsubst %.pas, %.o, $(SRCS))
OBJS := $(addprefix $(RTLDIR), $(OBJS))

all: $(OBJS)
