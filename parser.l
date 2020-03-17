%{

#include <stdlib.h>
#include "y.tab.h"

%}

blank [\n\t\r\b ]+
digit [0-9]
int {digit}*
float {digit}*\.{digit}+
string \".*\"
char '(\\[ntbr0])|.'
name [a-zA-Z][a-zA-Z0-9_]*

%%

blank {
    //nothing
}
"(" {
	printf("tOB ");
	return(tOB);
}
")" {
	printf("tCB ");
	return(tCB);
}


"[" {
	printf("tOC ");
	//return(tOC);
}
"]" {
	printf("tCC ");
	//return(tCC);
}


"{" {
	printf("tOH ");
	return(tOH);
}
"}" {
	printf("tCH ");
	return(tCH);
}
"+" {
	printf("tPLUS ");
	return(tPLUS);
}
"-" {
	printf("tMINUS ");
	return(tMINUS);
}
"*" {
	printf("tMUL ");
	return(tMUL);
}
"/" {
	printf("tDIV");
	return(tDIV);
}
"=" {
	printf("tAFF ");
	return(tAFF);
}
"==" {
	printf("tEQ ");
	return(tEQ);
}
"<" {
	printf("tSINF ");
	return(tSINF);
}
">" {
	printf("tSSUP ");
	return(tSSUP);
}
"<=" {
	printf("tINF ");
	return(tINF);
}
">=" {
	printf("tSUP ");
	return(tSUP);
}
"!=" {
	printf("tDIF ");
	return(tDIF);
}
"!" {
	printf("tNOT");
	return(tNOT);
}

"const" {
	printf("tCONST ");
	//return(tCONST);
}

"int" {
	printf("tINT ");
	return(tINT);
}
"void" {
    	printf("tVOID ");
	return(tVOID);
}
"char" {
	printf("tCHAR ");
	return(tCHAR);
}

" " {
	printf("tSPACE ");
	//return(tSPACE);
}
"\t" {
	printf("tTAB ");
	//return(tTAB);
}
"\n" {
	printf("tNL\n");
	//return(tNL);
}
"\b" {
	printf("tBS ");
	//return(tBS);
}
"," {
	printf("tCOMMA ");
	//return(tCOMMA);
}

";" {
	printf("tSC ");
	return(tSC);
}
"printf" {
	printf("tPRINTF ");
	return(tPRINTF);
}
"main" {
	printf("tMAIN ");
	return(tMAIN);
}
"return" {
    	printf("tRETURN");
	return(tRETURN);
}
{name} {
	printf("tNAME ");
    	yylval.str = yytext;
	return(tNAME);
}
{int} {
	printf("tINT_VAL ");
	yylval.i = atoi(yytext);
	return(tINT_VAL);
}
{float} {
	printf("tFLOAT_VAL ");
    	yylval.x = atof(yytext);
	return(tFLOAT_VAL);
}
{char} {
	printf("tCHAR_VAL ");
    	yylval.c = yytext[0];
	return(tCHAR_VAL);
}
{string} {
	printf("tSTR_VAL ");
    	yylval.str = yytext;
	return(tSTR_VAL);
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
