#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

typedef struct {
char* op
int ra
int rb
int rc
} t_instr;

t_instr instructionTable[MAX_SIZE];
int currentTableSize = 0;

void addInstruction(char* op, int ra, int rb, int rc) {
	instructionTable[currentTableSize].op = malloc(strlen(op));
	instructionTable[currentTableSize].op = op;
	instructionTable[currentTableSize].ra = ra;
	instructionTable[currentTableSize].rb = rb;
	instructionTable[currentTableSize].rc = rc;
	currentTableSize++;
}

//on recherche l'instruction du saut et on met à jour l'adresse
void updateInstruction() {
	t_instr currentInstr = instructionTable[currentTableSize-1];
	int currentIndex = currentTableSize-1;
	while(strcmp(currentInstr.op, "JMP") != 0) {
		currentIndex--;
		currentInstr = instructionTable[currentIndex];
	}
	instructionTable[currentIndex].ra = currentTableSize;
}