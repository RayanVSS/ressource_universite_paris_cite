#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <libgen.h>
#include <sys/param.h>
#include "tarutils.h"

char zeros[BLOCKSIZE] = {0};
char buf[BLOCKSIZE];
struct posix_header hd;


/* ajoute un fichier de nom filename à l'archive ouverte (fd)
 * retourne 0 en cas de succès, 1 en cas d'échec */
int tar_one_file(int fd, char * filename) {
  struct stat st; 
  struct posix_header * phd = &hd;

  /* TODO : création de l'entête; commencer par le remplir de 0, puis
   * renseigner au moins les champs indispensables : typeflag, name,
   * mode, size, et _en dernier_ checksum.  
   * Pour typeflag, mode et size, utiliser stat() */


  /* calcul de checksum : indispensable pour gnu tar :-( */
  set_checksum(phd);

  /* TODO : ouverture du fichier à copier */


  /* TODO : copie de l'entête dans l'archive */


  /* TODO : copie du fichier; ATTENTION à compléter le dernier bloc si
   * nécessaire */


  /* TODO : fermeture du fichier copié */


  return 0;
}



int main(int argc, char **argv){
  if (argc < 3) {
    fprintf(stderr, "Usage : %s file.tar f1 [... fn]\n", argv[0]);
    exit(1);
  }

  /* TODO : création du fichier d'archive */


  /* TODO : boucle principale pour ajouter chaque argv[i] l'un après
   * l'autre */


  /* TODO : finalisation : ajout de deux blocs vides */


  /* TODO : fermeture du fichier tar */


  exit(0);
}
