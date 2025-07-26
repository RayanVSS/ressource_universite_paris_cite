.PHONY: init clean

init:
	@sh -c 'if [ -e "work" ]; then echo "Erreur : le dossier \"work\" existe déjà"; exit 1; fi'
	cp -r template work
	@sh -c 'cd work; for f in ex-*.sh; do bash "$$f"; rm "$$f"; done'
	@sh -c 'cd work; for f in ex-*.tar*; do tar -xf "$$f"; rm "$$f"; done'

clean:
	@sh -c 'if [ -e "work" ]; then chmod -R u+rwx work; rm -rf work; fi'

