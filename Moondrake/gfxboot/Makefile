all: background.png fonts

background.png: ../background/Moondrake-tux-1024x768.xcf
	../../gimp/xcf2png -i $< -o $@ -a rgb
	pngcrush -ow $@

fonts: dejavu_sans_bold_14.pf2 droid_sans_mono_regular_11.pf2 moonlight_bold_20.pf2 moonlight_regular_20.pf2 moonlight_regular_50.pf2

dejavu_sans_bold_14.pf2: /usr/share/fonts/TTF/dejavu/DejaVuSans-Bold.ttf
	grub2-mkfont -v -a -s 14 -o $@ $< 

droid_sans_mono_regular_11.pf2: /usr/share/fonts/TTF/droid/DroidSansMono.ttf
	grub2-mkfont -v -a -s 11 -o $@ $<

moonlight_bold_20.pf2: /usr/share/fonts/TTF/gliphmaker.com/Moonlight.ttf
	grub2-mkfont -v -a -b -s 20 -o $@ $<

moonlight_regular_20.pf2: /usr/share/fonts/TTF/gliphmaker.com/Moonlight.ttf
	grub2-mkfont -v -a -s 20 -o $@ $<

moonlight_regular_50.pf2: /usr/share/fonts/TTF/gliphmaker.com/Moonlight.ttf
	grub2-mkfont -v -a -s 50 -o $@ $<

clean:
	rm -f background.png *pf2

install: all
	install -m644 background.png -D $(DESTDIR)/boot/grub2/themes/Moondrake/background.png
	install -m644 dejavu_sans_bold_14.pf2 -D $(DESTDIR)/boot/grub2/themes/Moondrake/dejavu_sans_bold_14.pf2
	install -m644 droid_sans_mono_regular_11.pf2 -D $(DESTDIR)/boot/grub2/themes/Moondrake/droid_sans_mono_regular_11.pf2
	install -m644 moonlight_bold_20.pf2 -D $(DESTDIR)/boot/grub2/themes/Moondrake/moonlight_bold_20.pf2
	install -m644 moonlight_regular_20.pf2 -D $(DESTDIR)/boot/grub2/themes/Moondrake/moonlight_regular_20.pf2
	install -m644 moonlight_regular_50.pf2 -D $(DESTDIR)/boot/grub2/themes/Moondrake/moonlight_regular_50.pf2

