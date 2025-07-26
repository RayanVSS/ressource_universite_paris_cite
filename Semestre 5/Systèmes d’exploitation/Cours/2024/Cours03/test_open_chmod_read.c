#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

int main() {
  char buf[32];
  int nb, fd = open("toto", O_RDWR /*O_RDONLY*/ /*O_WRONLY*/);
  if (fd < 0) {
    perror("problème d'ouverture");
    exit(1);
  }
  
  /* pour supprimer tous les droits d'accès au fichier */
  chmod("toto", 0);

  /* encore pire... que se passe-t-il si on _supprime_ le fichier (ou
   * plutôt, le lien vers le fichier) entre l'ouverture et la lecture? */
  // unlink("toto");
  /* vérification que le fichier (le lien) est bien supprimé */
  /* if (open("toto", O_RDWR) < 0) {
    perror("après suppression, 2e ouverture impossible");
  }*/

  if ( (nb=read(fd, buf, 32)) < 0 ) {
    perror("problème de lecture");
    exit(1);
  }
  write(1, buf, nb);

  if ( (nb=write(fd, buf, nb)) < 0 ) {
   perror("problème d'écriture");
   exit(1);
  }

  /* pour rétablir les droits */
  // chmod("toto", 0600);
  
  close(fd);
}
