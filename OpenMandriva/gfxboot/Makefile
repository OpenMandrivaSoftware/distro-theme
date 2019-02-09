all: fonts

fonts: gnu_unifont_regular_16.pf2

gnu_unifont_regular_16.pf2: /usr/share/fonts/X11/misc/unifont.pcf.gz
	grub2-mkfont -v -o $@ $<

clean:
	rm -f *pf2

install:
	install -d $(DESTDIR)/boot/grub2/themes/OpenMandriva
	install -m644 *.* $(DESTDIR)/boot/grub2/themes/OpenMandriva/
	install -m644 gnu_unifont_regular_16.pf2 -D $(DESTDIR)/boot/grub2/themes/OpenMandriva/gnu_unifont_regular_16.pf2

