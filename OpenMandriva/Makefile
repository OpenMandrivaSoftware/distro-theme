ifeq ($(NO_GRUB),true)
SUBDIRS=
else
SUBDIRS=gfxboot
endif

.PHONY: subdirs $(SUBDIRS) clean

subdirs: $(SUBDIRS)

ifneq (,$(SUBDIRS))
$(SUBDIRS):
	@exec $(MAKE) -C $@ $(MAKECMDGOALS)
endif
