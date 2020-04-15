%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include "symboltable.h"

#define INSTR_BUFFER_SIZE 1000 //increase if necessary
#define NONE 0

int yylex();
void yyerror(const char *s);

int tempAddrPointer = 100;

char instructionsBuffer[INSTR_BUFFER_SIZE];
char * currentBufferPointer = instructionsBuffer;

void appendInstruction(const char * instruction) {
	while((*currentBufferPointer++ = *instruction++) != '\0') {}
	currentBufferPointer--;
}

// use NONE when an argument is not needed for readability reasons
void instruction(const char * instruction, int arg1, int arg2, int arg3) {
	if (
		strcmp(instruction, "ADD") == 0 ||
		strcmp(instruction, "MUL") == 0 ||
		strcmp(instruction, "SOU") == 0 ||
		strcmp(instruction, "DIV") == 0 ||
		strcmp(instruction, "INF") == 0 ||
		strcmp(instruction, "SUP") == 0 ||
		strcmp(instruction, "EQU") == 0
	) {
		// 3 arguments instruction
		size_t neededSize = 1 + snprintf(NULL, 0, "%s\t%d\t%d\t%d\n", instruction, arg1, arg2, arg3);
		char instructionBuffer[neededSize];
		snprintf(instructionBuffer, sizeof(instructionBuffer), "%s\t%d\t%d\t%d\n", instruction, arg1, arg2, arg3);
		appendInstruction(instructionBuffer);
	} else if (
		strcmp(instruction, "COP") == 0 ||
		strcmp(instruction, "AFC") == 0 ||
		strcmp(instruction, "JMF") == 0
	) {
		// 2 arguments instruction
		size_t neededSize = 1 + snprintf(NULL, 0, "%s\t%d\t%d\n", instruction, arg1, arg2);
		char instructionBuffer[neededSize];
		snprintf(instructionBuffer, sizeof(instructionBuffer), "%s\t%d\t%d\n", instruction, arg1, arg2);
		appendInstruction(instructionBuffer);
	} else if (
		strcmp(instruction, "JMP") == 0 ||
		strcmp(instruction, "PRI") == 0
	) {
		// 1 argument instruction
		size_t neededSize = 1 + snprintf(NULL, 0, "%s\t%d\n", instruction, arg1);
		char instructionBuffer[neededSize];
		snprintf(instructionBuffer, sizeof(instructionBuffer), "%s\t%d\n", instruction, arg1);
		appendInstruction(instructionBuffer);
	} else {
		fprintf(stderr, "Fatal Error : Unknown instruction \"%s\"", instruction);
	}
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

	FILE * outputFile = fopen("output.s", "w");
	fprintf(outputFile, instructionsBuffer);
}
