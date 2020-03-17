%{

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

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

%token tINT tVOID tCHAR
%token tSPACE tTAB tNL tBS
%token tSC
%token tPRINTF
%token tMAIN

%token tNAME
%token tINT_VAL tFLOAT_VAL tSTR_VAL tCHAR_VAL
%token tRETURN

%start Program

%%

Program:
      tINT tMAIN tOB tCB Body
    | tVOID tMAIN tOB tCB Body
    | tCHAR tMAIN tOB tCB Body
    ;

Body:
      tOH Instruction tCH
    ;

Instruction:
      Type tNAME tAFF Expression tSC Instruction
    | Type tNAME tSC Instruction
    | tNAME tAFF Expression tSC Instruction
    | tPRINTF tOB tSTR_VAL tCB tSC Instruction
    | tRETURN tNAME tSC
    | tRETURN Valeur tSC
    | tRETURN tOB tNAME tCB tSC
    | tRETURN tOB Valeur tCB tSC
    ;

Type: 
      tINT
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
    ;

Valeur:
      tINT_VAL
    | tFLOAT_VAL
    | tCHAR_VAL
    | tSTR_VAL
    ;

%%

int yywrap(void) {
    return 1;
}

int main(void) {
    yylex();
}
