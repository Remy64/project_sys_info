#!/bin/bash

yacc -d parser.y
mv y.tab.h parser.y.h
mv y.tab.c parser.y.c
lex parser.l
mv lex.yy.c parser.l.c
sed -i 's/typedef int YYSTYPE;/typedef union { float x; int i; char * str; char c; } YYSTYPE;/' parser.y.c
sed -i 's/typedef int YYSTYPE;/typedef union { float x; int i; char * str; char c; } YYSTYPE;/' parser.y.h
gcc -c symboltable.c
gcc parser.y.c parser.l.c symboltable.o -ly -ll -o parser
rm -f symboltable.o
