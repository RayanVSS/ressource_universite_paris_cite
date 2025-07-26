#include <stdio.h>

char texte[6][32] = {
  "J'aime les gens qui doutent,",
  "Les gens qui trop écoutent",
  "Leur cœur se balancer",
  "J'aime les gens qui disent",
  "Et qui se contredisent",
  "Et sans se dénoncer",
};
char sep[3] = {' ', ' ', '\n'};


int main() {
  int i;
  char tmp[128];
  FILE * flot;

  flot = fopen("les-gens-qui-doutent", "w+");

  /* écriture de 6 lignes dans un fichier */
  for (i=0; i<6; i++) {
    fprintf(flot, "%s\n", texte[i]);
  }

  /* relecture et affichage ligne à ligne */
  fseek(flot, 0, SEEK_SET);
  while(fgets(tmp, 128, flot) != NULL) {
    printf("%s",tmp);
  }

  fclose(flot);

  printf("\n\n");

  flot = fopen("les-gens-qui-doutent-condense", "w");

  /* écriture de 2 lignes, en 6 fragments, dans un 2e fichier et sur 
   * la sortie standard */
  for (i=0; i<6; i++) {
    fprintf(flot, "%s%c", texte[i], sep[i%3]);
    printf("%s%c", texte[i], sep[i%3]);
  }

  fclose(flot);
}
