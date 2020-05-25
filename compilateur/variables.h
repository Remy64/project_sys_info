#ifndef VARIABLES_H
#define VARIABLES_H

#include <stdbool.h>

#define VARS_TABLE_MAX_SIZE 100
#define TEMP_VARS_FIRST_ADDR 100
#define MAX_TEMP_VARS 1000


void incrementDepth();
void decrementDepth();
int pushSymbol(char * id, bool isConst, bool isInit);
int getSymbolAddr(char * id);
bool isSymbolInit(int addr);
void initializeSymbol(int addr);
bool isSymbolConst(int addr);

int getTempVarAddr();
void freeTempVarAddr(int tempVarAddr);

#endif //VARIABLES_H
