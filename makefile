y.tab.c: parser.y
	yacc parser.y
lex.yy.c: parser.l
	lex parser.l
parser: lex.yy.c y.tab.c
	gcc y.tab.c lex.yy.c -ll -o parser 

