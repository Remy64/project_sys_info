%{

#include <stdlib.h>
#include "parser.h"

%}

blank [\n\t\r\b ]+
digit [0-9]
int {digit}*
float {digit}*\.{digit}+
char '(\\[ntbr0])|.'
name [a-zA-Z][a-zA-Z0-9_]*

%%

blank {
    	//nothing
}
"(" {
	//printf("tOB ");
	return(tOB);
}
")" {
	//printf("tCB ");
	return(tCB);
}


"[" {
	//printf("tOC ");
	//return(tOC);
}
"]" {
	//printf("tCC ");
	//return(tCC);
}


"{" {
	//printf("tOH ");
	return(tOH);
}
"}" {
	//printf("tCH ");
	return(tCH);
}
"+" {
	//printf("tPLUS ");
	return(tPLUS);
}
"-" {
	//printf("tMINUS ");
	return(tMINUS);
}
"*" {
	//printf("tMUL ");
	return(tMUL);
}
"/" {
	//printf("tDIV");
	return(tDIV);
}
"=" {
	//printf("tAFF ");
	return(tAFF);
}
"==" {
	//printf("tEQ ");
	return(tEQ);
}
"<" {
	//printf("tSINF ");
	return(tSINF);
}
">" {
	//printf("tSSUP ");
	return(tSSUP);
}
"<=" {
	//printf("tINF ");
	return(tINF);
}
">=" {
	//printf("tSUP ");
	return(tSUP);
}
"!=" {
	//printf("tDIF ");
	return(tDIF);
}
"!" {
	//printf("tNOT");
	return(tNOT);
}

"const" {
	//printf("tCONST ");
	return(tCONST);
}

"int" {
	//printf("tINT ");
	return(tINT);
}
"float" {
	//printf("tFLOAT ");
	return(tFLOAT);
}
"void" {
    	//printf("tVOID ");
	return(tVOID);
}
"char" {
	//printf("tCHAR ");
	return(tCHAR);
}


"," {
	//printf("tCOMMA ");
	//return(tCOMMA);
}

";" {
	//printf("tSC ");
	return(tSC);
}
"printf" {
	//printf("tPRINTF ");
	return(tPRINTF);
}
"main" {
	//printf("tMAIN ");
	return(tMAIN);
}
"return" {
    	//printf("tRETURN");
	return(tRETURN);
}
"if" {
	//printf("tIF ");
	return(tIF);
}
"else" {
	//printf("tELSE");
	return(tELSE);
}
{name} {
	//printf("tNAME ");
    	yylval.str = strdup(yytext);
	return(tNAME);
}
{int} {
	//printf("tINT_VAL ");
	yylval.i = atoi(yytext);
	return(tINT_VAL);
}
{float} {
	//printf("tFLOAT_VAL ");
    	yylval.x = atof(yytext);
	return(tFLOAT_VAL);
}
{char} {
	//printf("tCHAR_VAL ");
    	yylval.c = yytext[0];
	return(tCHAR_VAL);
}

%%

/*
int yywrap(void) {
	return 1;
}

int main(void) {
    yylex();
}
*/
