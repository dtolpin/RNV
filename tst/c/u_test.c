/* $Id: u_test.c,v 1.1 2003/12/24 10:51:56 dvd Exp $ */
#include <assert.h>
#include "u.h"

int main(int argc,char **argv) {
  int i;
  for(i=-1;i!=32768;++i) {
    printf("%#x is",i);
    if(u_base_char(i)) printf(" base");
    if(u_ideographic(i)) printf(" ideographic");
    if(u_combining_char(i)) printf(" combining");
    if(u_extender(i)) printf(" extender");
    if(u_digit(i)) printf(" digit");
    printf("\n");
  }
  return 0;
}
