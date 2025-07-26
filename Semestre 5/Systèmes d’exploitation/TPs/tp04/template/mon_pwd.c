#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <dirent.h>
#include <string.h>
#include <limits.h>

//ATTENTION: si le répertoire courant est toujours ./
//la variable courant elle correspond à un chemin du style "./../.."
//qui évoluera au fur et au mesure qu'on remonte à la racine.

//On limitera les tailles des chemins PATH_MAX



//retourne le nom du répertoire correspondant au chemin courant
char *nom_du_repertoire(char * courant) {
  // à adapter à partir de la question précédente
}


//est-ce que le répertoire correspondant au chemin courant
//est la racine
int est_racine(char * courant) {
 
}



//c'est là qu'on fait la récursion
char *  construit_chemin_aux(char * courant, char * pwd) {
 
}

//cette fonction retournera la référence absolue du répertoire courant ./
char *  construit_chemin() {
  //pwd est un chemin de style "/bidule/truc" où "bidule/truc" est la fin du pwd, à la fin ce sera le pwd
  char *  pwd = malloc (PATH_MAX* sizeof(char));
  // courant est un chemin du style "./../.."
  char *courant = malloc (PATH_MAX* sizeof(char));
  
  sprintf(courant,"."); 
  sprintf(pwd,"/");

  pwd = construit_chemin_aux(courant, pwd);

  free(courant);

  return pwd;
}

int main(int argc, char **argv) {
  char * pwd;
 
  pwd = construit_chemin();
  printf("%s\n", pwd);
  free(pwd);
  return 0;  
}
