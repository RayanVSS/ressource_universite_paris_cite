#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

void inode_type(char *file){
  struct stat st;

  /* comparer le comportement avec stat vs lstat */
  if (lstat(file, &st) == -1) {
    fprintf(stderr, "%s : %s\n", file, strerror(errno));
    return;
  }

  printf("%s est un ", file);
  if((st.st_mode & S_IFMT) == S_IFREG)  printf("fichier ordinaire\n");
  /* ou de manière équivalente :
  if(S_ISREG(st.st_mode))  printf("fichier ordinaire\n");
  */
  else if (S_ISDIR(st.st_mode))  printf("répertoire\n");
  else if (S_ISFIFO(st.st_mode))  printf("tube nommé\n");
  else if (S_ISLNK(st.st_mode))  printf("lien symbolique\n");
  else if (S_ISCHR(st.st_mode))  printf("fichier spécial en mode caractère\n");
  /* ... */
  else printf("?!?\n");

  /* tests des droits; attention au parenthésage */
  /* un cas simple */
  if ((st.st_mode & S_IRGRP) != 0) 
    printf("le groupe %d a les droits en lecture\n", st.st_gid);
  else printf("le groupe %d n'a pas les droits en lecture\n", st.st_gid);
  /* un cas plus compliqué */
  if ((st.st_mode & (S_IXUSR | S_IXGRP | S_IXOTH)) != 0) 
    printf("au moins un utilisateur a les droits en exécution\n", st.st_uid);
  else printf("aucun utilisateur n'a pas les droits en exécution\n", st.st_uid);

  /* ... */
}

int main(int argc, char **argv){
  int i;
  
  if(argc<2){
    fprintf(stderr, "usage : %s file1 [file2 ... fileN]\n", argv[0]);
    exit(1);
  }

  for(int i=1; i<argc; i++){
    inode_type(argv[i]);
  }
  
  return 0;
}
