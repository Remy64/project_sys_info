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

%token tINT tVOID
%token tSPACE tTAB tNL tBS tCOMMA
%token tSC
%token tPRINTF
%token tMAIN
%token tIF tWHILE tDO
%token tELSE

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
		freeTempVarAddr($4.i);
	} Instruction
	| tCONST Type tNAME tAFF Expression tSC {
		int varAddr = pushSymbol($3.str, true, true);
		instruction(COP, varAddr, $5.i, NONE);
		freeTempVarAddr($5.i);
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
		freeTempVarAddr($3.i);
	} Instruction
	| tPRINTF tOB Expression tCB tSC {
		instruction(PRI, $3.i, NONE, NONE);
                freeTempVarAddr($3.i);
	} Instruction
	| tIF tOB Expression tCB {
		incrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
		$1.i = instruction(JMF, $3.i, TEMP, NONE);
		freeTempVarAddr($3.i);
	} Body {
		amendInstructionArg($1.i, 2, getNbInstructions() + 1);
		decrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
	} tELSE {
		incrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
		$1.i = instruction(JMP, TEMP, NONE, NONE);

	} Body {
		amendInstructionArg($1.i, 1, getNbInstructions());
		decrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
	} Instruction
	| tIF tOB Expression tCB {
		incrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
		$1.i = instruction(JMF, $3.i, TEMP, NONE);
		freeTempVarAddr($3.i);
	} Body {
		amendInstructionArg($1.i, 2, getNbInstructions());
		decrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
	} Instruction
	| tWHILE {
		$1.i = getNbInstructions();
	} tOB Expression tCB {
		incrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
		$2.i = instruction(JMF, $4.i, TEMP, NONE);
		freeTempVarAddr($4.i);
		// it should be the line below since $3 is Expression, not $4, but the value of Expresson is in $4
		// $2.i = instruction(JMF, $3.i, TEMP, NONE);
		// freeTempVarAddr($3.i);
	} Body {
		instruction(JMP, $1.i, NONE, NONE);
		amendInstructionArg($2.i, 2, getNbInstructions());
		decrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
	} Instruction
	| tDO {
		incrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
		$1.i = getNbInstructions();
	} Body tWHILE tOB Expression tCB tSC {
		int addrForZero = getTempVarAddr();
		instruction(AFC, addrForZero, 0, NONE);
		instruction(EQU, $6.i, addrForZero, $6.i);
		freeTempVarAddr(addrForZero);
		instruction(JMF, $6.i, $1.i, NONE);
		freeTempVarAddr($6.i);
		// it should be the lines below since $5 is Expression, not $6, but the value of Expresson is in $6
		// instruction(EQU, $5.i, addrForZero, $5.i);
		// freeTempVarAddr(addrForZero);
		// instruction(JMF, $5.i, $1.i, NONE);
		// freeTempVarAddr($5.i);
		decrementDepth(); // ADDEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
	} Instruction
	| tRETURN Expression tSC {
		//"return <expression>;" acts like "printf(<expression>);"
		instruction(PRI, $2.i, NONE, NONE);
	}
	| /* epsilon */
	;

Type: 
	  tINT
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
		$$.i = $1.i;
		instruction(EQU, $$.i, $1.i, $3.i);
		int addrForZero = $3.i;
		instruction(AFC, addrForZero, 0, NONE);
		instruction(EQU, $$.i, addrForZero, $$.i);
		freeTempVarAddr(addrForZero);
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
		instruction(SUP, $$.i, $1.i, $3.i);
		int addrForOne = $3.i;
		instruction(AFC, addrForOne, 1, NONE);
		instruction(SOU, $$.i, addrForOne, $$.i);
		freeTempVarAddr(addrForOne);
	}
	| Expression tSUP Expression {
		$$.i = $1.i;
		instruction(INF, $$.i, $1.i, $3.i);
		int addrForOne = $3.i;
		instruction(AFC, addrForOne, 1, NONE);
		instruction(SOU, $$.i, addrForOne, $$.i);
		freeTempVarAddr(addrForOne);
	}
	| tNOT Expression {
		int addrForZero = getTempVarAddr();
		instruction(AFC, addrForZero, 0, NONE);
		$$.i = $2.i;
		instruction(EQU, $$.i, addrForZero, $2.i);
		freeTempVarAddr(addrForZero);
	}
	| tMINUS Expression {
		int addrForZero = getTempVarAddr();
		instruction(AFC, addrForZero, 0, NONE);
		$$.i = $2.i;
		instruction(SOU, $$.i, addrForZero, $2.i);
		freeTempVarAddr(addrForZero);
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
