all:: gencon-sf gencon-vfx

clean::
	rm -fv gencon-sf gencon-vfx

#gencon-gforth: gencon.fs
#	echo '#! /usr/bin/env gforth' > $@
#	cat $< >> $@
#	echo '1 arg nip 0= [if] .( usage: gencon <file>) cr bye [then]' >> $@
#	echo '1 arg included' >> $@
#	echo 'generate bye' >> $@
#	chmod +x $@

gencon-sf: gencon.fs
	sf include gencon.fs ':noname 1 argv dup if included generate else ." usage: gencon <file>" then 0 sys_exit ;' "'MAIN" ! program $@ bye

gencon-vfx: gencon.fs
	vfxlin 'synonym parse-word parse-name' 'synonym string, $$,' include gencon.fs ':noname 1 argv[ dup if zcount -verboseinclude included generate else ." usage: gencon <file>" then bye ;' is EntryPoint save $@ bye
