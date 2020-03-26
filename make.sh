yacc -d parser.y
mv y.tab.h parser.h
mv y.tab.c parser.y.c
lex parser.l
mv lex.yy.c parser.l.c
sed -i 's/typedef int YYSTYPE;/typedef union { float x; int i; char * str; char c; } YYSTYPE;/' parser.y.c
sed -i 's/typedef int YYSTYPE;/typedef union { float x; int i; char * str; char c; } YYSTYPE;/' parser.h
gcc parser.y.c parser.l.c -ly -ll -o parser

