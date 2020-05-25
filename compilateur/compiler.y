%{

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

#include "variables.h"
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
	  Type Declaration_Var Other_Declaration_Var tSC Instruction
	| tCONST Type Declaration_Const Other_Declaration_Const tSC Instruction
	| Assignment tSC Instruction
	| tPRINTF tOB Expression tCB tSC {
		instruction(PRI, $3.i, NONE, NONE);
                freeTempVarAddr($3.i);
	} Instruction
	| tIF tOB Expression tCB {
		incrementDepth();
		$1.i = instruction(JMF, $3.i, TEMP, NONE);
		freeTempVarAddr($3.i);
	} Body {
		$6.i = getNbInstructions(); // first free instruction address
		decrementDepth();
	} Else {
		// the boolean indicator is in $8, not $6 because {} counts as a symbol
		if($8.i) {
			// if - else
			amendInstructionArg($1.i, 2, $6.i + 1);
		} else {
			// if alone
			amendInstructionArg($1.i, 2, $6.i);
		}
	} Instruction
	| tWHILE {
		$1.i = getNbInstructions();
	} tOB Expression tCB {
		incrementDepth();
		$2.i = instruction(JMF, $4.i, TEMP, NONE);
		freeTempVarAddr($4.i);
		// Expression is in $4, not $3 because {} counts as a symbol
	} Body {
		instruction(JMP, $1.i, NONE, NONE);
		amendInstructionArg($2.i, 2, getNbInstructions());
		decrementDepth();
	} Instruction
	| tDO {
		incrementDepth();
		$1.i = getNbInstructions();
	} Body tWHILE tOB Expression tCB tSC {
		int addrForZero = getTempVarAddr();
		instruction(AFC, addrForZero, 0, NONE);
		instruction(EQU, $6.i, addrForZero, $6.i);
		freeTempVarAddr(addrForZero);
		instruction(JMF, $6.i, $1.i, NONE);
		freeTempVarAddr($6.i);
		// Expression is in $6, not $5 because {} counts as a symbol
		decrementDepth();
	} Instruction
	| tRETURN Expression tSC {
		// "return <expression>;" acts like "printf(<expression>);"
		instruction(PRI, $2.i, NONE, NONE);
	}
	| /* epsilon */
	;

Type: 
	  tINT
	;

Declaration_Var:
	  tNAME tAFF Expression { //declaration and assignment
		int varAddr = pushSymbol($1.str, false, true);
		instruction(COP, varAddr, $3.i, NONE);
		freeTempVarAddr($3.i);
	}
	| tNAME { //declaration only
		pushSymbol($1.str, false, false);
	}
	;

Declaration_Const:
	  tNAME tAFF Expression { //declaration and mandatory assignment for constants
		int varAddr = pushSymbol($1.str, true, true);
		instruction(COP, varAddr, $3.i, NONE);
		freeTempVarAddr($3.i);
	}
	;

Other_Declaration_Var:
	  tCOMMA Declaration_Var Other_Declaration_Var
	| /* epsilon */
	;

Other_Declaration_Const:
	  tCOMMA Declaration_Const Other_Declaration_Const
	| /* epsilon */
	;

Assignment:
	  tNAME tAFF Expression {
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
	}
	;

Else: 
	tELSE {
		incrementDepth();
		$1.i = instruction(JMP, TEMP, NONE, NONE);
	} Body {
		amendInstructionArg($1.i, 1, getNbInstructions());
		decrementDepth();
		$$.i = 1; // indicate there is an "else"
	}
	| /* epsilon */ {
		$$.i = 0; // indicate there is no "else"
	}
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
