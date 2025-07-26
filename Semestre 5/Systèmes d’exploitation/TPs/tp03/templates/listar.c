#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include "tarutils.h"

struct posix_header hd;

int main(int argc, char **argv){
  int fd, ret = 0;
  unsigned int filesize, filemode, nblocks;
  struct posix_header * phd = &hd;

  if (argc != 2) {
    fprintf(stderr, "Usage : %s file.tar\n", argv[0]);
    exit(1);
  }
  
  /* ouverture du fichier tar */
  fd = open(argv[1], O_RDONLY);
  if (fd < 0) { 
    perror("open"); 
    exit(1); 
  }

  /* boucle principale */
  while (1) {
    /* TODO : lecture de l'entête; vérifier que la lecture est bien complète */


    /* TODO : la fin de l'archive est atteinte si le bloc est rempli de zéros, 
     * et en particulier si name == "" */


    /* vérification de la checksum (facultatif) */
    if (!check_checksum(phd)) {
      fprintf(stderr, "Checksum erronée : %s\n", phd -> chksum);
      ret = 1;
      break;
    }

    /* TODO : calcul des droits, de la taille et du nombre de blocs occupés --
     * ce nombre est la partie entière supérieure de filesize / BLOCKSIZE, 
     * c'est-à-dire (filesize + BLOCKSIZE - 1) >> BLOCKBITS*/


    /* affichage des informations de l'entête : droits en octal, taille 
     * en décimal, nombre de blocs en décimal, nom du fichier */
    printf("%o\t%d\t%d\t%s\n", filemode, filesize, nblocks, phd -> name);

    /* TODO : saut à l'entête suivant */


  }

  /* TODO : fermeture du fichier tar */

  
  exit(ret);
}
