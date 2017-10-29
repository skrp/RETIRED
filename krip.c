//#################################
// KRIP - recursive file encryption
// ARG1 - target path
// ARG2 - dump path
#inclue <stdio.h>
int keygen(char *key3);


// FNS ###########################
int keygen(char *location, char *$key3, char *dump)
{
  FILE *fp; // TARGET FILE
  FILE *kfp; // KEY FILE
  if (fp = open(location, "r") == NULL)
    { printf("ERR read %s\n", argv[1]); exit(1); }
  strcat(dump, "key");
  if (kfp = open(dump, "w") == NULL)
    { printf("ERR create key\n"); exit(1); }
  uint32_t  = arc4random_uniform(LIM);
  krip(&key3, kfp);
}
