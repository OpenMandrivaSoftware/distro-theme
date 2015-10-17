SUBDIRS=background gfxboot plymouth

.PHONY: subdirs $(SUBDIRS)

$(MAKECMDGOALS) subdirs: $(SUBDIRS)

$(SUBDIRS):
	@exec $(MAKE) -C $@ $(MAKECMDGOALS)
