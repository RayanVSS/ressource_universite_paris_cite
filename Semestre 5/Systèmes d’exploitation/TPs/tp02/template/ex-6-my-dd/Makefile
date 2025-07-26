.PHONY: all clean distclean test

all: my-dd

my-dd: my-dd.c
	@bash -c 'echo_emph() { if [ -t 1 ] && command -v tput >/dev/null 2>&1; then echo -n "$$(tput bold)" 2>/dev/null; echo "$$@"; echo -ne "$$(tput sgr0)" 2>/dev/null; else echo "$$@"; fi; }; P=$$(basename "$$(cd .. && pwd)"); if [ "$$P" == "template" ]; then echo_emph -ne "\nErreur : "; echo -ne "Vous travaillez actuellement dans le répertoire template/, au lieu de work/ comme demandé dans l\x27énoncé. Fermez tous vos fichiers, remontez dans le répertoire "; echo_emph -ne "tp2/"; echo -ne ", et lancez \x27"; echo_emph -n "make init"; echo -ne "\x27. Puis, lancez \x27"; echo_emph -ne "git clean -fd; git restore ."; echo -ne "\x27 pour nettoyer le dépôt, et enfin, redescendez dans le répertoire "; echo_emph -ne "work/"; echo -ne " pour continuer votre travail.\n\n"; exit 1; fi'
	gcc -Wall -o my-dd my-dd.c

clean:

distclean: 
	rm -f my-dd

test: all
	$(ENV) bash test.sh
