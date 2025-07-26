#include <stdlib.h>
#include <unistd.h>
#include <limits.h>
#include <errno.h>
#include <stdint.h>
#include <inttypes.h>
#include <fcntl.h>
#include <getopt.h>

int parse_size(char * string, size_t * result);
int do_dd(int fd_in, int fd_out, size_t bs, int count);

/* `./my-dd -i <INFILE> -o <OUTFILE> -b <BLOCKSIZE> -c <COUNT>` 
 * a un comportement équivalent à 
 * `dd if=<INFILE> of=<OUTFILE> bs=<BLOCKSIZE> count=<COUNT> status=none`. 
 * Les arguments -i, -o, -b et -c sont optionnels, avec le même comportement 
 * par défaut que pour dd. */
int main(int argc, char * argv[]) {
  int result;
  char * in_file = NULL;
  char * out_file = NULL;
  
  int in_fd = STDIN_FILENO;
  int out_fd = STDOUT_FILENO;
  size_t bs = 512;
  int count = -1;

  int opt;
  while ((opt = getopt(argc, argv, "i:o:b:c:")) != -1) {
    switch (opt) {
    case 'i':
      in_file = optarg;
      break;
    case 'o':
      out_file = optarg;
      break;
    case 'b':
      if (!parse_size(optarg, &bs)) {
        result = 1;
        goto cleanup_return;
      }
      break;
    case 'c': {
      char *endp = optarg;
      errno = 0;
      uintmax_t value = strtoumax(optarg, &endp, 10);
      if (errno || endp == optarg || value > INT_MAX) {
        result = 1;
        goto cleanup_return;
      }
      count = value; }
      break;
    case '?':
      result = 1;
      goto cleanup_return;
      break;
    }
  }

  /* TODO [B] : si l'option -i était présente, ouvrir le fichier
   * correspondant en lecture seule, et mettre le descripteur de fichier
   * obtenu dans in_file. 
   * Ne pas oublier de tester s'il y a eu une erreur. */

  /* TODO [B] : si l'option -o était présente, ouvrir le fichier
   * correspondant en écriture. Si le fichier existait déjà, le tronquer;
   * si le fichier n'existait pas, le créer avec le mode 00666. 
   * Ne pas oublier de tester s'il y a eu une erreur. */

  /* TODO [A] : appeler do_dd() avec les bons arguments */

 cleanup_return:
  /* TODO [A] : refermer in_fd et out_fd. 
   * Ne pas oublier de tester s'il y a eu une erreur. */
  return result; 
}


/* Lit in_fd par blocs de bs octets et le recopie sur fd_out. 
 * Si count>=0, s'arrête après count blocs; sinon, lit fd_in jusqu'au bout.
 * Renvoie 0 en cas de succès et 1 en cas d'erreur. */
int do_dd(int fd_in, int fd_out, size_t bs, int count) {
  /* TODO [A] : à peu de choses près, le même code que my-cat */
}


/* Décode une taille en octets, donnée par un nombre éventuellement suivi
 * d'un suffixe multiplicatif (cf. man dd). 
 * En cas de succès, écrit le résultat dans *resultp et renvoie 1. 
 * En cas d'erreur, renvoie 0. */
int parse_size(char * string, size_t * resultp) {
  char *endp = string;
  uintmax_t multiplier = 1;
  errno = 0;
  uintmax_t value = strtoumax(string, &endp, 10);
  if (errno || endp == string) return 0;
  switch(endp[0]) {
  case 'c':
  case 0:
    multiplier = 1;
    break;
  case 'w':
    multiplier = 2LL;
    break;
  case 'b':
    multiplier = 512LL;
    break;
  case 'k':
    if (endp[1] == 'B') multiplier = 1000LL;
    else return 0;
    break;
  case 'K':
    multiplier = 1024;
    break;
  case 'M':
    if (endp[1] == 'B') multiplier = 1000LL*1000LL;
    else multiplier = 1024LL*1024LL;
    break;
  case 'x':
    if (endp[1] == 'M') multiplier = 1000LL*1000LL;
    else return 0;
    break;
  case 'G':
    if (endp[1] == 'B') multiplier = 1000LL*1000LL*1000LL;
    else multiplier = 1024LL*1024LL*1024LL;
    break;
  case 'T':
    if (endp[1] == 'B') multiplier = 1000LL*1000LL*1000LL*1000LL;
    else multiplier = 1024LL*1024LL*1024LL*1024LL;
    break;
  default: return 0;
  }
  if (value > SIZE_MAX/multiplier) return 0;
  *resultp = value * multiplier;
  return 1;
}
