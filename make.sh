lex parser.l
yacc -d parser.y
sed -i 's/typedef int YYSTYPE;/typedef union { float x; int i; char * str; char c; } YYSTYPE;/' y.tab.c
sed -i 's/typedef int YYSTYPE;/typedef union { float x; int i; char * str; char c; } YYSTYPE;/' y.tab.h
gcc y.tab.c lex.yy.c -ly -ll -o parser

