#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

char usage[] = " prend deux paramètres\n";

int main(int argc, char **argv) {
  int fd, nb;

  if (argc <= 2) {
    write(STDERR_FILENO, argv[0], strlen(argv[0]));
    write(STDERR_FILENO, usage, strlen(usage));
    return 1; 
  }

  /* ouverture en écriture, avec création si nécessaire du fichier de nom
   * argv[2]; le programme doit terminer avec la valeur de retour 1 en
   * cas d'erreur.  */

  // TODO : compléter

  /* écriture de la chaîne argv[1] dans argv[2]; terminer avec la valeur
   * de retour 1 en cas d'erreur. */

  // TODO : compléter

  /* fermeture du descripteur */

  // TODO : compléter

  return 0;
}
