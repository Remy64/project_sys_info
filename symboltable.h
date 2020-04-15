#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#define INT_TYPE 1
#define FLOAT_TYPE 2
#define CHAR_TYPE 3


void icnrementDepth();
void decrementDepth();
int pushSymbol(char * id, int type, bool isConst, bool isInit);
int getSymbolAddr(char * id);
bool isSymbolInit(int addr);
void initializeSymbol(int addr);
bool isSymbolConst(int addr);
