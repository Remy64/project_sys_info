#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "instructions.h"


typedef struct {
	Type type;
	int args[3];
} Instruction;


Instruction instructionsBuffer[NB_MAX_INSTR];
int currentBufferSize = 0;


int instruction(Type type, int arg1, int arg2, int arg3) {
	switch(type) {
		case ADD:
		case SOU:
		case MUL:
		case DIV:
		case INF:
		case SUP:
		case EQU:
		case COP:
		case AFC:
		case JMF:
		case JMP:
		case PRI:
			break;
		default:
			fprintf(stderr, "Fatal Error : The instruction type you provided is unknown");
			exit(-1);
	}
	instructionsBuffer[currentBufferSize] = (Instruction) {
		type,
		{arg1, arg2, arg3}
	};
	return currentBufferSize++;
}

int getNbInstructions() {
	return currentBufferSize;
}

void amendInstructionArg(int addr, int argNum, int newArg) {
	if(addr >= currentBufferSize || addr < 0) {
		fprintf(stderr, "Fatal Error : Impossible to amend instruction. The provided instruction address is incorrect");
		exit(-1);
	}
	if(argNum < 1 || argNum > 3) {
		fprintf(stderr, "Fatal Error : Invalid argument number. A valid argument number is 1, 2 or 3");
		exit(-1);
	}
	instructionsBuffer[addr].args[argNum-1] = newArg;
	/*
	switch(argNum) {
		case 1:
			instructionsBuffer[addr].arg1 = newArg;
			break;
		case 2:
			instructionsBuffer[addr].arg2 = newArg;
			break;
		case 3:
			instructionsBuffer[addr].arg3 = newArg;
			break;
		default:
			fprintf(stderr, "Fatal Error : Invalid argument number. A valid argument number is 1, 2 or 3");
			exit(-1);
	}
	*/
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
						strcpy(name, "SOU");
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
					instructionsBuffer[i].args[0],
					instructionsBuffer[i].args[1],
					instructionsBuffer[i].args[2]
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
					instructionsBuffer[i].args[0],
					instructionsBuffer[i].args[1]
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
					instructionsBuffer[i].args[0]
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

