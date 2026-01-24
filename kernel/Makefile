include ../vars.mk

FPFLAGS += -vehinw -Fu$(RTLDIR)

SRCS := $(wildcard *.pas)
RSRC := kernel.psf
OBJS := $(ARCH).o

OBJS += $(patsubst %.pas, %.o, $(SRCS))
OBJS += $(patsubst %.psf, %.psf.o, $(RSRC))
OBJS := $(addprefix $(OUTDIR)/, $(OBJS))

all: | $(OUTDIR)
all: $(OUTDIR)/kernel.elf

$(OUTDIR):
	@mkdir -p $@

$(OUTDIR)/kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -T$(ARCH)/link.ld -o$@ $^ $(RTLDIR)/rtl.o

$(OUTDIR)/%.psf.o: %.psf
	$(LD) -r -bbinary -o$@ $<

$(OUTDIR)/$(ARCH).o:
	@make -C$(ARCH) FPFLAGS="$(FPFLAGS)"

$(OUTDIR)/%.o: %.pas $(wildcard *.inc)
	$(FP) $(FPFLAGS) -Fi$(ARCH) -Fu$(ARCH) -o$@ $<
