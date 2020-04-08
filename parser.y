%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include "symboltable.h"

int yylex();
void yyerror(const char *s);

int tempAddrPointer = 100;

void operation(const char * operation, int addr1, int addr2) {
	printf("%s %d %d %d", operation, addr1, addr1, addr2);
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
		//printf("Type : %d", $1.i);
		//printf("Var Name : %s", $2.str);
		//printf("Expression : %d", $4.i);
		int varAddr = pushSymbol($2.str, $1.i, false, true);
		printf("COP %d %d", varAddr, $4.i);
	} Instruction
	| Type tCONST tNAME tAFF Expression tSC {
		int varAddr = pushSymbol($3.str, $1.i, true, true);
		printf("COP %d %d", varAddr, $5.i);
	} Instruction
	| Type tNAME tSC {
		pushSymbol($2.str, $1.i, false, false);
	} Instruction
	| tNAME tAFF Expression tSC {
		//printf("Var Name : %s", $1.str);
		//printf("Expression : %d", $3.i);
		int varAddr = getSymbolAddr($1.str);
		if(isSymbolConst(varAddr)) {
			printf("FATAL ERROR : Can not affect a value to a constant");
			exit(-1);
		}
		if(!isSymbolInit(varAddr)) {
			initializeSymbol(varAddr);
		}
		printf("COP %d %d", varAddr, $3.i);
	} Instruction
	| tPRINTF tOB Expression tCB tSC Instruction
	| tRETURN Expression tSC
	| /* epsilon */
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
		//printf("ADD %d %d %d", $$, $1, $3);
		operation("ADD", $1.i, $2.i);
	}
	| Expression tMINUS Expression {
		$$.i = $1.i;
		operation("SOU", $1.i, $2.i);
	}
	| Expression tMUL Expression {
		$$.i = $1.i;
		operation("MUL", $1.i, $2.i);
	}
	| Expression tDIV Expression {
		$$.i = $1.i;
		operation("DIV", $1.i, $2.i);
	}
	| Expression tEQ Expression {
		$$.i = $1.i;
		operation("EQU", $1.i, $2.i);
	}
	| Expression tDIF Expression {
		//DIF = EQU
		$$.i = $1.i;
		operation("EQU", $1.i, $2.i);
	}
	| Expression tSINF Expression {
		$$.i = $1.i;
		operation("INF", $1.i, $2.i);
	}
	| Expression tSSUP Expression {
		$$.i = $1.i;
		operation("SUP", $1.i, $2.i);
	}
	| Expression tINF Expression {
		$$.i = $1.i;
		operation("INF", $1.i, $2.i);
	}
	| Expression tSUP Expression {
		$$.i = $1.i;
		operation("SUP", $1.i, $2.i);
	}
	| tNOT Expression {
		//le not n'existe pas
		$$.i = $2.i;
	}
	| tMINUS Expression {
		$$.i = tempAddrPointer;
		printf("COP %d 0", tempAddrPointer);
		printf("SOU %d %d %d", $$.i, tempAddrPointer, $2.i);
		tempAddrPointer++;
	}            %prec tNOT
	| Valeur {
		$$.i = tempAddrPointer;
		printf("AFC %d %d", tempAddrPointer, $1.i);
		tempAddrPointer++;
	}
	| tNAME {
		$$.i = tempAddrPointer;
		int varAddr = getSymbolAddr($1.str);
		if(!isSymbolInit(varAddr)) {
			printf("FATAL ERROR : Can not get the value of an unitialized variable");
			exit(-1);
		}
		printf("COP %d %d", $$.i, varAddr);
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
	printf("%s\n", s);
}

int main(void) {
	//yylex();
	yyparse();
}
