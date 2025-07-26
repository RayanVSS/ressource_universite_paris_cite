#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include "tarutils.h"

#define MIN(a,b) (((a)<(b))?(a):(b))

char buf[BLOCKSIZE];
struct posix_header hd;

/* extraie de l'archive dont fd est un descripteur le fichier décrit par
 * l'entête phd : crée un fichier de nom phd -> name
 * et de contenu constitué des filesize octets suivants de l'archive.
 * Attention à respecter les droits phd -> mode */
int extract(int fd, struct posix_header * phd, unsigned int filesize) {

  /* TODO : vérification du type de fichier : seuls les REGTYPE et AREGTYPE 
   * sont supportés */


  /* TODO : création du fichier avec les bons droits */


  /* TODO : recopie du contenu; ATTENTION au dernier bloc! */ 

  
  /* TODO : refermer le descripteur */

  return 0;
}


int main(int argc, char **argv){
  int ret = 0, all;
  char * filename = NULL;
  struct posix_header * phd = &hd;

  switch (argc) {
    case 2 : all = 1; break;
    case 3 : all = 0; filename = argv[2]; break;
    default :
      fprintf(stderr, "Usage : %s file.tar [file]\n", argv[0]);
      exit(1);
  }

  /* TODO : ouverture du fichier tar */


  /* boucle principale */
  while (1) {
    /* TODO : lecture de l'entête; vérifier que la lecture est bien complète */


    /* TODO : la fin de l'archive est atteinte si le bloc est rempli de zéros, 
     * et en particulier si name == "" */

     /* vérification de checksum (facultatif) */
     if (!check_checksum(phd)) {
       fprintf(stderr, "Checksum erronée : %s\n", phd -> chksum);
       ret = 1;
       break;
     }

    /* TODO : la taille et le nombre de blocs sont toujours utiles */


    /* TODO[1] s'il s'agit du fichier cherché, le désarchiver puis
     * quitter; sinon, sauter à l'entête suivant */ 


    /* TODO[2] s'il s'agit d'une extraction complète (all == 1),
     * désarchiver le fichier et continuer (sauf en cas d'erreur)*/


  }

  /* TODO : fermeture du fichier tar */
 

  exit(ret);
}
