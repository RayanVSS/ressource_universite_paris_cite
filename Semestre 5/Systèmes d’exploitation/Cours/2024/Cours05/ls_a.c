#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <fcntl.h>

void ls(char *dir){
  struct dirent *entry;
  DIR *dirp = opendir(dir);
  struct stat st;
  char ref[128];
 
  if (dirp == NULL) {
    perror("opendir");
    exit(1);
  }
  
  while((entry=readdir(dirp))){
    /* if (entry->d_name[0] == '.') continue; */

    /* si on souhaite accéder à un des fichiers (stat, open...), deux
     * solutions : 
     * 1. construction d'une référence valide */
    sprintf(ref, "%s/%s", dir, entry->d_name);  
    if (stat(ref, &st) == -1) 
      perror("stat");
    else printf("%o\t", st.st_mode);

    /* 2. utiliser les appels ...at(fd, ref,...) qui permettent de
     * désigner le fichier par une référence relative au répertoire (déjà
     * ouvert) de descripteur fd */
    if (fstatat(dirfd(dirp), entry->d_name, &st, AT_SYMLINK_NOFOLLOW) == -1) 
      perror("stat");
    else printf("%o\t", st.st_mode);

    printf("%lld\t%s\n", entry->d_ino, entry->d_name);
  }

  closedir(dirp);
}

int main(int argc, char ** argv){
  if (argc==1) ls(".");
  else ls(argv[1]);
  
  return 0;
}
