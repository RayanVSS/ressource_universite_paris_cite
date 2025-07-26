#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>

int main() {
  printf("un flag obligatoire pour le type d'accès :\n");
  printf("\tO_RDONLY = %4o\n\tO_WRONLY = %4o\n\tO_RDWR   = %4o\n", O_RDONLY, O_WRONLY, O_RDWR);

  printf("\néventuellement combiné avec : \n");
  printf("\tO_APPEND = %4o\n\tO_CREAT  = %4o\n\tO_TRUNC  = %4o\n\tO_EXCL   = %4o\n\t...\n", O_APPEND, O_CREAT, O_TRUNC, O_EXCL);

  printf("\nExemples : \n");
  printf("\tO_RDWR   = %4o\n\tO_APPEND = %4o\n\tO_CREAT  = %4o\n=> O_RDWR | O_APPEND | O_CREAT = %4o\n", O_RDWR, O_APPEND, O_CREAT, O_RDWR | O_APPEND | O_CREAT);
  printf("\n");
  printf("\tO_WRONLY = %4o\n\tO_CREAT  = %4o\n\tO_TRUNC  = %4o\n=> O_WRONLY | O_CREAT | O_TRUNC = %4o\n", O_WRONLY, O_CREAT, O_TRUNC, O_WRONLY | O_CREAT | O_TRUNC);
  printf("\n");
  printf("\tO_WRONLY = %4o\n\tO_CREAT  = %4o\n\tO_EXCL   = %4o\n=> O_WRONLY | O_CREAT | O_EXCL = %4o\n", O_WRONLY, O_CREAT, O_EXCL, O_WRONLY | O_CREAT | O_EXCL);
}

