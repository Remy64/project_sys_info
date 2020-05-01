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

typedef enum {
	ADD,
	SOU,
	MUL,
	DIV,
	INF,
	SUP,
	EQU,
	COP,
	AFC,
	JMF,
	JMP,
	PRI
} Type;

typedef struct {
	Type type;
	int arg1;
	int arg2;
	int arg3;
} Instruction;

Instruction instructionsBuffer[NB_MAX_INSTR];
int currentBufferSize = 0;

// adds an instructions to the instructions buffer
// note : use NONE when an argument is not needed for readability reasons
void instruction(Type type, int arg1, int arg2, int arg3) {
	instructionsBuffer[currentBufferSize] = (Instruction) {
		type,
		arg1,
		arg2,
		arg3
	};
	currentBufferSize++;
}

// print the instructions found in the instructions buffer
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
		instruction(COP, varAddr, $4.i, NONE);
	} Instruction
	| Type tCONST tNAME tAFF Expression tSC {
		int varAddr = pushSymbol($3.str, $1.i, true, true);
		instruction(COP, varAddr, $5.i, NONE);
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
		instruction(COP, varAddr, $3.i, NONE);
	} Instruction
	| tPRINTF tOB Expression tCB tSC Instruction
	| tRETURN Expression tSC
	| tIF tOB Expression tCB {
		$1.i = currentBufferSize;
		instruction(JMP, 0, NONE, NONE);
	} 
	Body {
		instructionsBuffer[$1.i].arg1 = currentBufferSize + 2;
	}Else Instruction
	| /* epsilon */
	;

Else:
	
	|tELSE {
		$1.i = currentBufferSize;
		instruction(JMP, 0, NONE, NONE);

	}

	 Body {
	 	instructionsBuffer[$1.i].arg1 = currentBufferSize + 1;
	 }
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
		instruction(ADD, $$.i, $1.i, $3.i);
	}
	| Expression tMINUS Expression {
		$$.i = $1.i;
		instruction(SOU, $$.i, $1.i, $3.i);
	}
	| Expression tMUL Expression {
		$$.i = $1.i;
		instruction(MUL, $$.i, $1.i, $3.i);
	}
	| Expression tDIV Expression {
		$$.i = $1.i;
		instruction(DIV, $$.i, $1.i, $3.i);
	}
	| Expression tEQ Expression {
		$$.i = $1.i;
		instruction(EQU, $$.i, $1.i, $3.i);
	}
	| Expression tDIF Expression {
		//DIF = EQU
		$$.i = $1.i;
		instruction(EQU, $$.i, $1.i, $3.i);
	}
	| Expression tSINF Expression {
		$$.i = $1.i;
		instruction(INF, $$.i, $1.i, $3.i);
	}
	| Expression tSSUP Expression {
		$$.i = $1.i;
		instruction(SUP, $$.i, $1.i, $3.i);
	}
	| Expression tINF Expression {
		$$.i = $1.i;
		instruction(INF, $$.i, $1.i, $3.i);
	}
	| Expression tSUP Expression {
		$$.i = $1.i;
		instruction(SUP, $$.i, $1.i, $3.i);
	}
	| tNOT Expression {
		//le not n'existe pas
		$$.i = $2.i;
	}
	| tMINUS Expression {
		$$.i = tempAddrPointer;
		instruction(AFC, tempAddrPointer, 0, NONE);
		instruction(SOU, $$.i, tempAddrPointer, $2.i);
		tempAddrPointer++;
	}            %prec tNOT
	| Valeur {
		$$.i = tempAddrPointer;
		instruction(AFC, tempAddrPointer, $1.i, NONE);
		tempAddrPointer++;
	}
	| tNAME {
		$$.i = tempAddrPointer;
		int varAddr = getSymbolAddr($1.str);
		if(!isSymbolInit(varAddr)) {
			fprintf(stderr, "FATAL ERROR : Can not get the value of an unitialized variable");
			exit(-1);
		}
		instruction(COP, $$.i, varAddr, NONE);
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
