NAME=distro-theme
PACKAGE=distro-theme
VERSION=1.4.28
# set default resoltuion for background here
DEFAULT_RES:=1920x1080
FALLBACK_RES:=1024x768

THEMES=Moondrake OpenMandriva

FILES=$(THEMES) Makefile common gimp extra-backgrounds
sharedir=/usr/share
configdir=/etc

# https://abf.rosalinux.ru/omv_software/distro-theme
SVNSOFT=svn+ssh://svn.mandriva.com/svn/soft/theme/mandriva-theme/
SVNNAME=svn+ssh://svn.mandriva.com/svn/packages/cooker/mandriva-theme/current/

all:

install:
	mkdir -p $(DESTDIR)$(prefix)$(sharedir)/mdk/backgrounds/
	mkdir -p $(DESTDIR)$(prefix)/$(sharedir)/mdk/screensaver
	mkdir -p $(DESTDIR)$(prefix)/$(sharedir)/mdk/backgrounds
	mkdir -p $(DESTDIR)$(prefix)/$(sharedir)/icons
	install -m 644 common/screensaver/*.jpg $(DESTDIR)$(prefix)$(sharedir)/mdk/screensaver
	install -m 644 extra-backgrounds/*.*g $(DESTDIR)$(prefix)$(sharedir)/mdk/backgrounds
	install -m644 */background/*.*g $(DESTDIR)$(prefix)$(sharedir)/mdk/backgrounds
	install -m644 */icons/*.*g $(DESTDIR)$(prefix)$(sharedir)/icons
	@for t in $(THEMES); do \
          set -x; set -e; \
	  install -d $(DESTDIR)$(prefix)/$(sharedir)/plymouth/themes/$$t; \
	  install -m644 $$t/plymouth/*.script $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/; \
	  install -m644 common/plymouth/*.png $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/; \
	  install -m644 $$t/plymouth/*.plymouth $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/; \
	  install -m644 $$t/plymouth/*.png $(DESTDIR)$(prefix)$(sharedir)/plymouth/themes/$$t/; \
	  install -d $(DESTDIR)/boot/grub2/themes/$$t; \
	  install -d $(DESTDIR)/boot/grub2/themes/$$t/icons; \
	  install -m644 $$t/gfxboot/*.* $(DESTDIR)/boot/grub2/themes/$$t/; \
	  if [ -d $$t/icons/gfxboot/ ]; then \
	  install -m644 $$t/icons/gfxboot/*.* $(DESTDIR)/boot/grub2/themes/$$t/icons; \
	  fi; \
	  if [ ! $$t == "OpenMandriva" ]; then \
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
	git archive --format=tar --prefix=$(NAME)-$(VERSION)/ HEAD | xz -2ec > $(NAME)-$(VERSION).tar.xz;
	$(info $(NAME)-$(VERSION).tar.xz is ready)

dist-old: cleandist export tar

cleandist:
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).tar.bz2

export:
	svn export -q -rBASE . $(NAME)-$(VERSION)

localdist: cleandist localcopy tar

dir:
	mkdir $(NAME)-$(VERSION)

tar:
	tar cvfa $(NAME).tar.xz $(NAME)-$(VERSION)
	rm -rf $(NAME)-$(VERSION)

localcopy: dir
	tar c --exclude=.svn $(FILES) | tar xf -C $(NAME)-$(VERSION)


clean:
	@for i in $(SUBDIRS);do	make -C $$i clean;done
	rm -f *~ \#*\#

svntag:
	svn cp -m 'version $(VERSION)' $(SVNSOFT)/trunk $(SVNNAME)/tag/v$(VERSION)
