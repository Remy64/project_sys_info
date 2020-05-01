#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "instructions.h"


typedef struct Instruction {
	Type type;
	int arg1;
	int arg2;
	int arg3;
} Instruction;


Instruction instructionsBuffer[NB_MAX_INSTR];
int currentBufferSize = 0;


void instruction(Type type, int arg1, int arg2, int arg3) {
	instructionsBuffer[currentBufferSize] = (Instruction) {
		type,
		arg1,
		arg2,
		arg3
	};
	currentBufferSize++;
}

void printInstructions() {
	char instructionsStrBuffer[NB_MAX_INSTR * INSTR_MAX_SIZE];
	char * currentStrBufferPointer = instructionsStrBuffer;

	for(int i = 0; i < currentBufferSize; i++) {
		int maxCopyOnBuffer = instructionsStrBuffer + (NB_MAX_INSTR * INSTR_MAX_SIZE) * sizeof(char) - currentStrBufferPointer;
		char name[4];
		int nbCharsCopied;
		switch(instructionsBuffer[i].type) {
			case ADD:
			case SOU:
			case MUL:
			case DIV:
			case INF:
			case SUP:
			case EQU:
				// 3 arguments instruction
				switch(instructionsBuffer[i].type) {
					case ADD:
						strcpy(name, "ADD");
						break;
					case SOU:
						strcpy(name, "SUB");
						break;
					case MUL:
						strcpy(name, "MUL");
						break;
					case DIV:
						strcpy(name, "DIV");
						break;
					case INF:
						strcpy(name, "INF");
						break;
					case SUP:
						strcpy(name, "SUP");
						break;
					case EQU:
						strcpy(name, "EQU");
						break;
					default:
						fprintf(stderr, "Fatal error : instruction type \"%d\" does not exist\n", instructionsBuffer[i].type);
						exit(-1);
				}
				nbCharsCopied = snprintf(
					currentStrBufferPointer,
					maxCopyOnBuffer,
					"%s\t%d\t%d\t%d\n",
					name,
					instructionsBuffer[i].arg1,
					instructionsBuffer[i].arg2,
					instructionsBuffer[i].arg3
				);
				break;
			case COP:
			case AFC:
			case JMF:
				// 2 arguments instruction
				switch(instructionsBuffer[i].type) {
					case COP:
						strcpy(name, "COP");
						break;
					case AFC:
						strcpy(name, "AFC");
						break;
					case JMF:
						strcpy(name, "JMF");
						break;
					default:
						fprintf(stderr, "Fatal error : instruction type \"%d\" does not exist\n", instructionsBuffer[i].type);
						exit(-1);
				}
				nbCharsCopied = snprintf(
					currentStrBufferPointer,
					maxCopyOnBuffer,
					"%s\t%d\t%d\n",
					name,
					instructionsBuffer[i].arg1,
					instructionsBuffer[i].arg2
				);
				break;
			case JMP:
			case PRI:
				// 1 argument instruction
				switch(instructionsBuffer[i].type) {
					case JMP:
						strcpy(name, "JMP");
						break;
					case PRI:
						strcpy(name, "PRI");
						break;
					default:
						fprintf(stderr, "Fatal error : instruction type \"%d\" does not exist\n", instructionsBuffer[i].type);
						exit(-1);
				}
				nbCharsCopied = snprintf(
					currentStrBufferPointer,
					maxCopyOnBuffer,
					"%s\t%d\n",
					name,
					instructionsBuffer[i].arg1
				);
				break;
			default:				
				fprintf(stderr, "Fatal error : instruction type \"%d\" does not exist\n", instructionsBuffer[i].type);
				exit(-1);
		}
		currentStrBufferPointer += nbCharsCopied;
	}

	FILE * outputFile = fopen("output.s", "w");
	fprintf(outputFile, instructionsStrBuffer);
}

