%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>

#include "symboltable.h"
#include "instructions.h"


int yylex();
void yyerror(const char *s);

int tempAddrPointer = 100;

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
		int varAddr = pushSymbol($2.str, false, true);
		instruction(COP, varAddr, $4.i, NONE);
	} Instruction
	| Type tCONST tNAME tAFF Expression tSC {
		int varAddr = pushSymbol($3.str, true, true);
		instruction(COP, varAddr, $5.i, NONE);
	} Instruction
	| Type tNAME tSC {
		pushSymbol($2.str, false, false);
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
	  tINT
	| tFLOAT
	| tVOID
	| tCHAR
	;

Expression:
	  tOB Expression tCB {
		$$.i = $2.i;
	}
	| Expression tPLUS Expression {
		$$.i = $1.i;
		instruction(ADD, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| Expression tMINUS Expression {
		$$.i = $1.i;
		instruction(SOU, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| Expression tMUL Expression {
		$$.i = $1.i;
		instruction(MUL, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| Expression tDIV Expression {
		$$.i = $1.i;
		instruction(DIV, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| Expression tEQ Expression {
		$$.i = $1.i;
		instruction(EQU, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| Expression tDIF Expression {
		//DIF = EQU
		$$.i = $1.i;
		instruction(EQU, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| Expression tSINF Expression {
		$$.i = $1.i;
		instruction(INF, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| Expression tSSUP Expression {
		$$.i = $1.i;
		instruction(SUP, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| Expression tINF Expression {
		$$.i = $1.i;
		instruction(INF, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| Expression tSUP Expression {
		$$.i = $1.i;
		instruction(SUP, $$.i, $1.i, $3.i);
		freeTempVarAddr($3.i);
	}
	| tNOT Expression {
		//le not n'existe pas
		$$.i = $2.i;
	}
	| tMINUS Expression {
		$$.i = getTempVarAddr();
		instruction(AFC, $$.i, 0, NONE);
		instruction(SOU, $$.i, $$.i, $2.i);
		freeTempVarAddr($2.i);
	}            %prec tNOT
	| Valeur {
		$$.i = getTempVarAddr();
		instruction(AFC, $$.i, $1.i, NONE);
	}
	| tNAME {
		$$.i = getTempVarAddr();
		int varAddr = getSymbolAddr($1.str);
		if(!isSymbolInit(varAddr)) {
			fprintf(stderr, "FATAL ERROR : Can not get the value of an unitialized variable");
			exit(-1);
		}
		instruction(COP, $$.i, varAddr, NONE);
	}
	;

Valeur:
	  tINT_VAL
	| tFLOAT_VAL
	| tCHAR_VAL
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
