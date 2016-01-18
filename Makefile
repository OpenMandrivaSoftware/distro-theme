NAME=distro-theme
PACKAGE=distro-theme
VERSION=1.4.37
# set default resolution for background here
DEFAULT_RES:=1920x1440
FALLBACK_RES:=1024x768

THEMES:=Moondrake OpenMandriva

SUBDIRS=$(THEMES)

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

FILES=$(THEMES) Makefile common gimp
sharedir=/usr/share
configdir=/etc

# https://abf.rosalinux.ru/software/distro-theme
SVNSOFT=svn+ssh://svn.mandriva.com/svn/soft/theme/mandriva-theme/
SVNNAME=svn+ssh://svn.mandriva.com/svn/packages/cooker/mandriva-theme/current/

all:

install:
	mkdir -p $(DESTDIR)$(prefix)/$(sharedir)/mdk/screensaver
	mkdir -p $(DESTDIR)$(prefix)/$(sharedir)/mdk/backgrounds
	mkdir -p $(DESTDIR)$(prefix)/$(sharedir)/icons
	install -m644 */extra-backgrounds/*.*g $(DESTDIR)$(prefix)$(sharedir)/mdk/backgrounds
	install -m644 */background/*.*g $(DESTDIR)$(prefix)$(sharedir)/mdk/backgrounds
	install -m644 */icons/*.*g $(DESTDIR)$(prefix)$(sharedir)/icons
	@for t in $(THEMES); do \
          set -x; set -e; \
	  [ -d $$t/screensaver ] && install -m644 $$t/screensaver/*.??g $(DESTDIR)$(prefix)/$(sharedir)/mdk/screensaver; \
	  install -d $(DESTDIR)$(prefix)/$(sharedir)/plymouth/themes/$$t; \
	  install -m644 $$t/plymouth/*.script $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/; \
	  install -m644 $$t/plymouth/*.plymouth $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/; \
	  install -m644 $$t/plymouth/*.png $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/; \
	  install -d $(DESTDIR)$(prefix)$(sharedir)/gfxboot/themes/$$t;  \
	  install -d $(DESTDIR)/boot/grub2/themes/$$t; \
	  install -d $(DESTDIR)/boot/grub2/themes/$$t/icons; \
	  if [ -f $$t/gfxboot/welcome.png ]; then \
	    convert $$t/gfxboot/welcome.png $(DESTDIR)$(prefix)$(sharedir)/gfxboot/themes/$$t/welcome.jpg; \
	    rm $$t/gfxboot/welcome.png; \
	  fi; \
	  if [ -f $$t/gfxboot/back.png ]; then \
	    convert $$t/gfxboot/back.png $(DESTDIR)$(prefix)$(sharedir)/gfxboot/themes/$$t/back.jpg; \
	  fi; \
	  install -m644 $$t/gfxboot/*.* $(DESTDIR)/boot/grub2/themes/$$t/; \
	  install -m644 $$t/gfxboot/theme.txt $(DESTDIR)/boot/grub2/themes/$$t/; \
	  if [ -d $$t/icons/gfxboot/ ]; then \
	  install -m644 $$t/icons/gfxboot/*.* $(DESTDIR)/boot/grub2/themes/$$t/icons; \
	  fi; \
	  if [ ! -e $$t/gfxboot/background.png ] &&  [ ! -e $$t/plymouth/background.png ] && [ ! -e $$t/plymouth/suspend.png ]; then \
	    if [ -e $$t/background/$$t-$(DEFAULT_RES).png ]; then \
		    install -m644 $$t/background/$$t-$(DEFAULT_RES).png $(DESTDIR)/boot/grub2/themes/$$t/background.png; \
		    install -m644 $$t/background/$$t-$(DEFAULT_RES).png $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/background.png; \
		    convert -colorspace Gray $$t/background/$$t-$(DEFAULT_RES).png $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/suspend.png; \
	    elif [ -e $$t/background/$$t-$(FALLBACK_RES).png ]; then \
		    install -m644 $$t/background/$$t-$(FALLBACK_RES).png $(DESTDIR)/boot/grub2/themes/$$t/background.png; \
		    install -m644 $$t/background/$$t-$(FALLBACK_RES).png $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/background.png; \
		    convert -colorspace Gray $$t/background/$$t-$(FALLBACK_RES).png $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/suspend.png; \
	    fi; \
	    if [ -e $$t/background/$$t-$(DEFAULT_RES).jpg ]; then \
		    convert $$t/background/$$t-$(DEFAULT_RES).jpg $(DESTDIR)/boot/grub2/themes/$$t/background.png \
		    && convert $$t/background/$$t-$(DEFAULT_RES).jpg $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/background.png; \
		    convert -colorspace Gray $$t/background/$$t-$(DEFAULT_RES).jpg $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/suspend.png; \
	    elif [ -e $$t/background/$$t-$(FALLBACK_RES).jpg ]; then \
		    convert $$t/background/$$t-$(FALLBACK_RES).jpg $(DESTDIR)/boot/grub2/themes/$$t/background.png \
		    && convert $$t/background/$$t-$(FALLBACK_RES).jpg $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/background.png; \
		    convert -colorspace Gray $$t/background/$$t-$(FALLBACK_RES).jpg $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/suspend.png; \
	    fi; \
	  fi; \
	done

log: ChangeLog

ChangeLog:
	@if test -d "$$PWD/.git"; then \
	  git --no-pager log --format="%ai %aN %n%n%x09* %s%d%n" > $@.tmp \
	  && mv -f $@.tmp $@ \
	  && git commit ChangeLog -m 'generated changelog' \
	  && if [ -e ".git/svn" ]; then \
	    git svn dcommit ; \
	    fi \
	  || (rm -f  $@.tmp; \
	 echo Failed to generate ChangeLog, your ChangeLog may be outdated >&2; \
	 (test -f $@ || echo git-log is required to generate this file >> $@)); \
	else \
	 svn2cl --accum --authors ../common/username.xml; \
	 rm -f *.bak;  \
	fi;

dist:
	git archive --format=tar --prefix=$(NAME)-$(VERSION)/ HEAD | xz -2vec -T0 > $(NAME)-$(VERSION).tar.xz;
	$(info $(NAME)-$(VERSION).tar.xz is ready)
	git tag $(NAME)-$(VERSION)

dist-old: cleandist export tar

cleandist:
	rm -rf $(PACKAGE)-$(VERSION).tar.xz

export:
	svn export -q -rBASE . $(NAME)-$(VERSION)

localdist: cleandist localcopy tar

dir:
	mkdir $(NAME)-$(VERSION)

tar:
	tar cvf $(NAME).tar $(NAME)-$(VERSION)
	rm -rf $(NAME)-$(VERSION)

localcopy: dir
	tar c --exclude=.svn $(FILES) | tar x -C $(NAME)-$(VERSION)



clean:
	@for i in $(SUBDIRS);do	make -C $$i clean;done
	rm -f *~ \#*\#

png2jpg:
	@/bin/cp -f gimp/scripts/gimp-normalize-to-bootsplash.scm tmp-gimp-command
	@cat gimp/scripts/gimp-convert-to-jpeg.scm >> tmp-gimp-command
	@for i in */gfxboot/*.png ; do \
	    echo \(gimp-normalize-to-bootsplash 1.0 \"$$i\" \"`dirname $$i`/`basename $$i .png`.jpg\"\) >> tmp-gimp-command; \
	done
	@for i in */background/*.png ; do \
            echo \(gimp-convert-to-jpeg 0.98 \"$$i\" \"`dirname $$i`/`basename $$i .png`.jpg\"\) >> tmp-gimp-command; \
	done
	@echo \(gimp-quit 1\) >> tmp-gimp-command
	@echo running gimp to convert images
	@cat tmp-gimp-command | gimp  --console-messages -i  -d  -b -
	@rm -f tmp-gimp-command
#	GIMP2_DIRECTORY=`pwd`/gimp gimp  --console-messages -i -d  -b '(begin (gimp-normalize-to-bootsplash-dirs "1.0" "*" "bootsplash/data/*.png") (gimp-quit 1))'
#	GIMP2_DIRECTORY=`pwd`/gimp gimp --console-messages -i -d -b '(begin (gimp-normalize-to-bootsplash-dirs "1.0" "*" "gfxboot/*.png") (gimp-quit 1))'

svntag:
	svn cp -m 'version $(VERSION)' $(SVNSOFT)/trunk $(SVNNAME)/tag/v$(VERSION)
