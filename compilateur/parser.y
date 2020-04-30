%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include "symboltable.h"

#define NB_MAX_INSTR 1000 //increase if necessary
#define INSTR_MAX_SIZE 100 //idem
#define NONE -1

int yylex();
void yyerror(const char *s);

int tempAddrPointer = 100;

typedef struct {
	char * name;
	int arg1;
	int arg2;
	int arg3;
} Instruction;

Instruction instructionsBuffer[NB_MAX_INSTR];
int currentBufferSize = 0;

// adds an instructions to the instructions buffer
// note : use NONE when an argument is not needed for readability reasons
void instruction(const char * instruction, int arg1, int arg2, int arg3) {
	instructionsBuffer[currentBufferSize] = (Instruction) {
		.name = strdup(instruction),
		.arg1 = arg1,
		.arg2 = arg2,
		.arg3 = arg3
	};
	currentBufferSize++;
}

void printInstructions() {
	char instructionsStrBuffer[NB_MAX_INSTR * INSTR_MAX_SIZE];
	char * currentStrBufferPointer = instructionsStrBuffer;

	for(int i = 0; i < currentBufferSize; i++) {
		int maxCopyOnBuffer = instructionsStrBuffer + (NB_MAX_INSTR * INSTR_MAX_SIZE) * sizeof(char) - currentStrBufferPointer;
		if (
			strcmp(instructionsBuffer[i].name, "ADD") == 0 ||
			strcmp(instructionsBuffer[i].name, "MUL") == 0 ||
			strcmp(instructionsBuffer[i].name, "SOU") == 0 ||
			strcmp(instructionsBuffer[i].name, "DIV") == 0 ||
			strcmp(instructionsBuffer[i].name, "INF") == 0 ||
			strcmp(instructionsBuffer[i].name, "SUP") == 0 ||
			strcmp(instructionsBuffer[i].name, "EQU") == 0
		) {
			// 3 arguments instruction
			int nbCharsCopied = snprintf(
				currentStrBufferPointer,
				maxCopyOnBuffer,
				"%s\t%d\t%d\t%d\n",
				instructionsBuffer[i].name,
				instructionsBuffer[i].arg1,
				instructionsBuffer[i].arg2,
				instructionsBuffer[i].arg3
			);
			currentStrBufferPointer += nbCharsCopied;
		} else if (
			strcmp(instructionsBuffer[i].name, "COP") == 0 ||
			strcmp(instructionsBuffer[i].name, "AFC") == 0 ||
			strcmp(instructionsBuffer[i].name, "JMF") == 0
		) {
			// 2 arguments instruction
			int nbCharsCopied = snprintf(
				currentStrBufferPointer,
				maxCopyOnBuffer,
				"%s\t%d\t%d\n",
				instructionsBuffer[i].name,
				instructionsBuffer[i].arg1,
				instructionsBuffer[i].arg2
			);
			currentStrBufferPointer += nbCharsCopied;
		} else if (
			strcmp(instructionsBuffer[i].name, "JMP") == 0 ||
			strcmp(instructionsBuffer[i].name, "PRI") == 0
		) {
			// 1 argument instruction
			int nbCharsCopied = snprintf(
				currentStrBufferPointer,
				maxCopyOnBuffer, "%s\t%d\n",
				instructionsBuffer[i].name,
				instructionsBuffer[i].arg1
			);
			currentStrBufferPointer += nbCharsCopied;
		} else {
			fprintf(stderr, "Fatal Error : Unknown instruction \"%s\"", instruction);
			exit(-1);
		}
	}

	FILE * outputFile = fopen("output.s", "w");
	fprintf(outputFile, instructionsStrBuffer);
}

%}


%right tAFF

%left tEQ tDIF tSINF tSSUP tINF tSUP

%left tPLUS tMINUS
%left tMUL tDIV

%right tNOT


%token tCB tOB
%token tOC tCC
%token tOH tCH

%token tINT tVOID tCHAR tFLOAT
%token tSPACE tTAB tNL tBS
%token tSC
%token tPRINTF
%token tMAIN
%token tIF tELSE

%token tCONST
%token tNAME
%token tINT_VAL tFLOAT_VAL tCHAR_VAL
%token tRETURN

%start Program

%%

Program:
	  tINT tMAIN tOB tCB Body
	| tVOID tMAIN tOB tCB Body
	;

Body:
	  tOH Instruction tCH
	;

Instruction:
	  Type tNAME tAFF Expression tSC {
		int varAddr = pushSymbol($2.str, $1.i, false, true);
		instruction("COP", varAddr, $4.i, NONE);
	} Instruction
	| Type tCONST tNAME tAFF Expression tSC {
		int varAddr = pushSymbol($3.str, $1.i, true, true);
		instruction("COP", varAddr, $5.i, NONE);
	} Instruction
	| Type tNAME tSC {
		pushSymbol($2.str, $1.i, false, false);
	} Instruction
	| tNAME tAFF Expression tSC {
		int varAddr = getSymbolAddr($1.str);
		if(isSymbolConst(varAddr)) {
			fprintf(stderr, "FATAL ERROR : Can not affect a value to a constant");
			exit(-1);
		}
		if(!isSymbolInit(varAddr)) {
			initializeSymbol(varAddr);
		}
		instruction("COP", varAddr, $3.i, NONE);
	} Instruction
	| tPRINTF tOB Expression tCB tSC Instruction
	| tRETURN Expression tSC
	| tIF tOB Expression tCB Body Else Instruction
	| /* epsilon */
	;

Else:
	
	|tELSE Body 
	;

Type: 
	  tINT {
		$$.i = INT_TYPE;
	}
	| tFLOAT {
		$$.i = FLOAT_TYPE;
	}
	| tVOID
	| tCHAR {
		$$.i = CHAR_TYPE;
	}
	;

Expression:
	  tOB Expression tCB {
		$$.i = $2.i;
	}
	| Expression tPLUS Expression {
		$$.i = $1.i;
		instruction("ADD", $$.i, $1.i, $3.i);
	}
	| Expression tMINUS Expression {
		$$.i = $1.i;
		instruction("SOU", $$.i, $1.i, $3.i);
	}
	| Expression tMUL Expression {
		$$.i = $1.i;
		instruction("MUL", $$.i, $1.i, $3.i);
	}
	| Expression tDIV Expression {
		$$.i = $1.i;
		instruction("DIV", $$.i, $1.i, $3.i);
	}
	| Expression tEQ Expression {
		$$.i = $1.i;
		instruction("EQU", $$.i, $1.i, $3.i);
	}
	| Expression tDIF Expression {
		//DIF = EQU
		$$.i = $1.i;
		instruction("EQU", $$.i, $1.i, $3.i);
	}
	| Expression tSINF Expression {
		$$.i = $1.i;
		instruction("INF", $$.i, $1.i, $3.i);
	}
	| Expression tSSUP Expression {
		$$.i = $1.i;
		instruction("SUP", $$.i, $1.i, $3.i);
	}
	| Expression tINF Expression {
		$$.i = $1.i;
		instruction("INF", $$.i, $1.i, $3.i);
	}
	| Expression tSUP Expression {
		$$.i = $1.i;
		instruction("SUP", $$.i, $1.i, $3.i);
	}
	| tNOT Expression {
		//le not n'existe pas
		$$.i = $2.i;
	}
	| tMINUS Expression {
		$$.i = tempAddrPointer;
		instruction("AFC", tempAddrPointer, 0, NONE);
		instruction("SOU", $$.i, tempAddrPointer, $2.i);
		tempAddrPointer++;
	}            %prec tNOT
	| Valeur {
		$$.i = tempAddrPointer;
		instruction("AFC", tempAddrPointer, $1.i, NONE);
		tempAddrPointer++;
	}
	| tNAME {
		$$.i = tempAddrPointer;
		int varAddr = getSymbolAddr($1.str);
		if(!isSymbolInit(varAddr)) {
			fprintf(stderr, "FATAL ERROR : Can not get the value of an unitialized variable");
			exit(-1);
		}
		instruction("COP", $$.i, varAddr, NONE);
		tempAddrPointer++;
	}
	;

Valeur:
	  tINT_VAL {
		$$.i = $1.i;
	}
	| tFLOAT_VAL {
		$$.i = (int)$1.x;
	}
	| tCHAR_VAL {
		$$.i = (int)$1.c;
	}
	;

%%

int yywrap(void) {
	return 1;
}

void yyerror(const char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
	yyparse();
	printInstructions();
}
