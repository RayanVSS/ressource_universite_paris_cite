.PHONY: init clean

init: 
	@sh -c 'if [ -e "work" ]; then echo "Erreur : le dossier \"work\" existe déjà"; exit 1; fi'
	cp -r template work

clean:
	@sh -c 'if [ -e "work" ]; then chmod -R u+rwx work; rm -rf work; fi'
