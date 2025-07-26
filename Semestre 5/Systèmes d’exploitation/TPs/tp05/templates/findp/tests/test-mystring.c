#define _DEFAULT_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "../mystring.h"

#ifndef STATIC
#include <dlfcn.h>
void * rtld_main_program = NULL;
#endif

struct string * prepare() {
  struct string * str = malloc(sizeof(*str));
  if (!str) return NULL;
  
  str->capacity = 20;
  str->data = malloc(str->capacity);
  if (!str->data) { free(str); return NULL; }
  
  strcpy(str->data, "0123456789");
  str->length = strlen(str->data);

  return str;
}

int test_new () {
#ifndef STATIC
  struct string * (*p_string_new)(size_t capacity) = dlsym(rtld_main_program, "string_new");
#else
  struct string * (*p_string_new)(size_t capacity) = &string_new;
#endif
  if (!p_string_new) return 0;

  size_t capacity = 1024;
  struct string * str = (*p_string_new)(capacity);
  if (!str) return 0;

  int ret = 1;
  if (str->capacity != capacity) ret = 0;
  if (str->length != 0) ret = 0;
  if (str->data[0] != 0) ret = 0;

  memset(str->data, 0, capacity);

  free(str->data);
  free(str);
  return ret;
}
  
int test_delete () {
#ifndef STATIC
  void (*p_string_delete)(struct string * str) = dlsym(rtld_main_program, "string_delete");
#else
  void (*p_string_delete)(struct string * str) = &string_delete;
#endif
  if (!p_string_delete) return 0;

  struct string * str = prepare();
  if (!str) return 0;
  
  (*p_string_delete)(str);
  return 1;
}
  
int test_append () {
#ifndef STATIC
  int (*p_string_append)(struct string * dest, char * src) = dlsym(rtld_main_program, "string_append");
#else
  int (*p_string_append)(struct string * dest, char * src) = &string_append;
#endif
  
  if (!p_string_append) return 0;

  struct string * str = prepare();
  if (!str) return 0;
  
  int ret = 1;
  
  if ((*p_string_append)(str, "01234") == 0) ret = 0;
  if (str->capacity != 20) ret = 0;
  if (str->length != 15) ret = 0;
  if (strcmp(str->data, "012345678901234") != 0) ret = 0;

  (*p_string_append)(str, "56789");
  
  free(str->data);
  free(str);
  return ret;
}

int test_truncate () {
#ifndef STATIC
  void (*p_string_truncate)(struct string * dest, size_t nchars) = dlsym(rtld_main_program, "string_truncate");
#else
  void (*p_string_truncate)(struct string * dest, size_t nchars) = &string_truncate;
#endif
  if (!p_string_truncate) return 0;

  struct string * str = prepare();
  if (!str) return 0;
  
  int ret = 1;
  
  (*p_string_truncate)(str, 3);
  if (str->capacity != 20) ret = 0;
  if (str->length != 7) ret = 0;
  if (strcmp(str->data, "0123456") != 0) ret = 0;

  (*p_string_truncate)(str, 30);
  if (str->capacity != 20) ret = 0;
  if (str->length != 0) ret = 0;
  if (strcmp(str->data, "") != 0) ret = 0;
  
  free(str->data);
  free(str);
  return ret;
}


int main(int argc, char **argv) {
#ifndef STATIC
  rtld_main_program = dlopen(NULL, RTLD_LAZY);
  if (!rtld_main_program) return 1;
#endif
  int ret = 1;
  
  if (argc == 1) {
    if (test_new() && test_delete() && test_append() && test_truncate()) ret = 0;
  }
  else {
    if (strcmp(argv[1], "new") == 0) {
      if (test_new()) ret = 0;
    }
    if (strcmp(argv[1], "delete") == 0) {
      if (test_delete()) ret = 0;
    }
    if (strcmp(argv[1], "append") == 0) {
      if (test_append()) ret = 0;
      else return 1;
    }
    if (strcmp(argv[1], "truncate") == 0) {
      if (test_truncate()) ret = 0;
      else return 1;
    }
  }

#ifndef STATIC
  dlclose(rtld_main_program);
#endif
  return ret;
}
