/* marche presqu'à tous les coups car le père se met généralement en
 * place plus vite que le fils; mais bloque tout de même de temps en
 * temps. 
 */


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

char *pere = "\033[34m[pere]\033[m";
char *fils = "\033[32m[fils]\033[m";
char *moi;

void bip(int sig) {
  dprintf(STDOUT_FILENO, "%s bip\n", moi);
}

int main(int argc,char *argv[]) {
  int pid, status;

  moi = pere;
  dprintf(STDOUT_FILENO, "==================================================\n");
  dprintf(STDOUT_FILENO, "%s lancement du processus %d\n", moi, getpid());

  /* impérativement **avant** le fork !!! */
  struct sigaction act = { 0 };
  act.sa_handler = bip;
  sigaction(SIGUSR1, &act, NULL); 

  switch (pid=fork()) {
    case -1 :
      exit(2);

    case 0 :
      moi = fils;
      dprintf(STDOUT_FILENO, "%s lancement du processus %d\n", moi, getpid());

      /* v2 : envoi du fils au père */
      dprintf(STDOUT_FILENO, "%s envoi du signal SIGUSR1 au processus %d\n", moi, getppid());
      kill(getppid(), SIGUSR1);
      exit(0);

    default :
      dprintf(STDOUT_FILENO, "%s processus fils %d créé\n", moi, pid);

      /* v2 : envoi du fils au père */
      pause();
      dprintf(STDOUT_FILENO, "%s signal bien reçu\n", moi);
      wait(NULL);
  }

  return 0;
}

