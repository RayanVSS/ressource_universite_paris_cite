#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>

int main(int argc, char **argv){
  int fd, nb;
  char c, buf[32];

  assert(argc>1);

  fd = open(argv[1], O_RDONLY);
  if (fd < 0) {
    perror("échec ouverture");
    return 1;
  }
  
  /* lecture d'un seul caractère */
  nb = read(fd, &c, 1);
  printf("%d caractère lu : %c\n", nb, c);
  
  /* lecture d'un bloc d'(au plus) 32 octets */
  /* précaution utile : préremplir le buffer avec des 0 */
  memset(buf, 0, 32);
  
  while ( (nb = read(fd, buf, 32)) > 0 ) {
  /* affichage avec write sur la sortie standard en contrôlant le nombre
   * d'octets pertinents vs tout le buffer */
    write(STDOUT_FILENO, buf, nb);
    write(STDOUT_FILENO, " || ", 4);
    write(STDOUT_FILENO, buf, 32);
    write(STDOUT_FILENO, "\n", 1);
  /* affichage avec printf en faisant confiance -- ne fonctionne *que* si
   * les octets lus sont bien suivis par un caractère nul '\0', ce qui
   * n'est pas assuré ici */
    printf("%d caractère(s) lu(s) : __%s__\n", nb, buf);
  }

  if (nb<0) {
    perror("échec lecture");
    close(fd);
    return 2;
  } 
  
  printf("fin de fichier atteinte\n");
  close(fd);
 
  return 0;
}
