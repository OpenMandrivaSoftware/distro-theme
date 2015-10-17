all: pngs

GIMPTOOL=../../gimp/xcf2png
BACKGROUNDS_GIMP=Moondrake-1024x768.xcf Moondrake-tux-1024x768.xcf

BACKGROUNDS_PNG=Moondrake-1920x1440.png Moondrake-tux-1920x1440.png Moondrake-tux-1920x1440-opaque.png Moondrake-1024x768.png Moondrake-tux-1024x768.png

Moondrake-1920x1440.png: Moondrake-tux-1920x1440.xcf
	$(GIMPTOOL) -i $< -o $@ -a indexed -r "Face" -r "Mid left half star" -a indexed -c 7

Moondrake-tux-1920x1440.png: Moondrake-tux-1920x1440.xcf
	$(GIMPTOOL) -i $< -o $@ -a indexed -c 170

Moondrake-tux-1920x1440-opaque.png: Moondrake-tux-1920x1440.xcf
	$(GIMPTOOL) -i $< -o $@ -a rgb -r "Mid star" -r "Mid bottom star" -r "North west star" -r "Mid left half star" -t 35

Moondrake-1024x768.png: Moondrake-tux-1024x768.xcf
	$(GIMPTOOL) -i $< -o $@ -a indexed -r "Face" -r "Mid left half star" -a indexed -c 7

Moondrake-tux-1024x768.png: Moondrake-tux-1024x768.xcf
	$(GIMPTOOL) -i $< -o $@ -a indexed -c 170

pngs: $(BACKGROUNDS_PNG)

$(GIMPTOOL): clean pngs

clean:
	rm -f $(BACKGROUNDS_PNG)

install: all
	@for i in $(BACKGROUNDS_PNG); do install -p -m644 $$i -D $(DESTDIR)/usr/share/mdk/backgrounds/$$i; done
