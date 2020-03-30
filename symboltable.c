#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "symboltable.h"

#define MAX_SIZE 1000
#define INT_TYPE 1
#define CHAR_TYPE 2

typedef struct {
	char * id;
	bool isConst;
	bool isInit;
	int depth;
} t_symbol;


t_symbol symbolTable[MAX_SIZE];
int currentDepth = 0;
int currentTableSize = 0; //current real size of the table


void incrementDepth() {
	currentDepth++;
}

//symbols are automatically popped when depth is decremented
void decrementDepth() {
	for(int i=currentTableSize-1; i>=0 && symbolTable[i].depth == currentDepth; i--) {
		currentTableSize--;
	}
	currentDepth--;
}

//called when one wants to declare a variable
void pushSymbol(char * id, int type, bool isConst, bool isInit) {
	for(int i=0; i<currentTableSize; i++) {
		if(strcmp(id, symbolTable[i].id) == 0 && currentDepth == symbolTable[i].depth) {
			printf("Fatal Error : Two variables with the same name can not be declared in the same scope");
			exit(-1);
		}
	}
	currentTableSize++;
	strcpy(symbolTable[currentTableSize].id, id);
	symbolTable[currentTableSize].isConst = isConst;
	symbolTable[currentTableSize].isInit = isInit;
	symbolTable[currentTableSize].depth = currentDepth;
}

//called when one wants to get the address of a symbol to write assembly code for example
//also used is this file
int getSymbolAddr(char * id) {
	int i;
	for(i=currentTableSize; i>=0 && strcmp(id, symbolTable[i].id) != 0; i++);
	return i-1;
}

//called when one wants to use the value of a symbol to check if it has one
bool isSymbolInit(char * id) {
	return symbolTable[getSymbolAddr(id)].isInit;
}

//called when one affects a value to a symbol
void initializeSymbol(char * id) {
	symbolTable[getSymbolAddr(id)].isInit = true;
}

//called when one wants to affect a symbol with a new value to know whether it a constant or not
bool isSymbolConst(char * id) {
	return symbolTable[getSymbolAddr(id)].isConst;
}
