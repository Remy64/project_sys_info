%{

#include <stdlib.h>
#include <string.h>
#include "parser.h"

%}

blank [\n\t\r\b ]+
digit [0-9]
int {digit}+
int_exp {digit}+e{digit}+
int_dec {digit}+\.{digit}+
name [a-zA-Z][a-zA-Z0-9_]*

%%

blank {
    	//nothing
}
"(" {
	return(tOB);
}
")" {
	return(tCB);
}
"{" {
	return(tOH);
}
"}" {
	return(tCH);
}
"+" {
	return(tPLUS);
}
"-" {
	return(tMINUS);
}
"*" {
	return(tMUL);
}
"/" {
	return(tDIV);
}
"=" {
	return(tAFF);
}
"==" {
	return(tEQ);
}
"<" {
	return(tSINF);
}
">" {
	return(tSSUP);
}
"<=" {
	return(tINF);
}
">=" {
	return(tSUP);
}
"!=" {
	return(tDIF);
}
"!" {
	return(tNOT);
}

"const" {
	return(tCONST);
}

"int" {
	return(tINT);
}
"void" {
	return(tVOID);
}


"," {
	return(tCOMMA);
}

";" {
	return(tSC);
}
"printf" {
	return(tPRINTF);
}
"main" {
	return(tMAIN);
}
"return" {
	return(tRETURN);
}
"if" {
	return(tIF);
}
"else" {
	return(tELSE);
}
"while" {
	return(tWHILE);
}
"do" {
	return(tDO);
}
{name} {
    	yylval.str = strdup(yytext);
	return(tNAME);
}
{int_exp} {
	char * parts[2];
	for(int i=0;  i<2 && (parts[i] = strsep(&yytext, "e")) != NULL; i++) {}

	int res = atoi(parts[0]);
	int pow = atoi(parts[1]);
	for(int i=0; i<pow; i++) {
		res *= 10;
	}

	yylval.i = res;
	return(tINT_VAL);
}
{int_dec} {
    	yylval.i = (int)atof(yytext);
	return(tINT_VAL);
}
{int} {
	yylval.i = atoi(yytext);
	return(tINT_VAL);
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
