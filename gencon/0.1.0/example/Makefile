# assumes parent dir has a 'gencon' executable

CFLAGS=-Wformat=0

constants.fs: gencon
	./$< > $@

gencon.c: gencon.fs
	../gencon $< > $@
	# I can't for the life of me get VFX to shut up
	sed -i 's/Including gencon.fs//' $@

gencon: gencon.c
	$(CC) $(CFLAGS) -o $@ $<


clean::
	rm -fv constants.fs gencon.c gencon

gforth::
	gforth -e 'include ../gencon.fs include gencon.fs generate bye' > gencon.c
	make constants.fs
