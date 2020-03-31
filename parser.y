%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include "symboltable.h"

int yylex();
void yyerror(const char *s);

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
	  Type tNAME tAFF Expression tSC Instruction
	| Type tNAME tSC Instruction
	| tNAME tAFF Expression tSC Instruction
	| tPRINTF tOB Expression tCB tSC Instruction
	| tRETURN Expression tSC
	//| tRETURN tOB Expression tCB tSC
	| /* epsilon */
	;

Type: 
	  tINT
	| tFLOAT
	| tVOID
	| tCHAR
	;

Expression:
	  tOB Expression tCB
	| Expression tPLUS Expression
	| Expression tMINUS Expression
	| Expression tMUL Expression
	| Expression tDIV Expression
	| Expression tEQ Expression
	| Expression tDIF Expression
	| Expression tSINF Expression
	| Expression tSSUP Expression
	| Expression tINF Expression
	| Expression tSUP Expression
	| tNOT Expression
	| tMINUS Expression             %prec tNOT
	| Valeur
	| tNAME
	;

Valeur:
	  tINT_VAL {
		$$ = $1;
	}
	| tFLOAT_VAL {
		$$ = $1;
	}
	| tCHAR_VAL {
		$$ = $1;
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
