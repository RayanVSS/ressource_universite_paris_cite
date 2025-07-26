#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

/* à tester avec strace en redirigeant la sortie sur un terminal 
 * vs autre chose (un fichier ordinaire ou un tube par exemple) */
int main() {
  printf("salut!\n");
  sleep(1);
  printf("coucou, ");
  /* fflush(stdout); */
  sleep(1);
  printf("me revoilou!");
  sleep(1);
  printf("\n");
  sleep(1);
  printf("un p'tit tour et puis s'en va...");
  /* comparer le comportement dans les 2 cas suivants : */
  exit(0);
  //_exit(0);
}
  
