SUBDIRS=gfxboot

.PHONY: subdirs $(SUBDIRS) clean

subdirs: $(SUBDIRS)

$(SUBDIRS):
	@exec $(MAKE) -C $@ $(MAKECMDGOALS)
