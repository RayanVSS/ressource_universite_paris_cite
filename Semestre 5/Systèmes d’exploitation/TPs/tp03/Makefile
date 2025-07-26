.PHONY: init tarexamples

init: work tarexamples

work: templates
	cp -r templates work

tarexamples :
	echo "Z'ai cru voir passer un 'rominet" >| titi
	echo "Faprifti" >| grosminet
	chmod ug+x grosminet
	tar cf titi.tar titi grosminet
	rm titi grosminet
	head -c 2048 titi.tar >| sans_zeros.tar
	head -c 1545 titi.tar >| tronque.tar
	mv titi.tar sans_zeros.tar tronque.tar /tmp
	(cd templates; tar cf tarutils.tar tarutils.c tarutils.h ; mv tarutils.tar /tmp)
