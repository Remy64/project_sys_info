# default target, called by a simple "make"
all: compiler

# build the compiler
compiler:
	yacc -d parser.y
	mv y.tab.h parser.h
	mv y.tab.c parser.y.c
	lex parser.l
	mv lex.yy.c parser.l.c
	sed -i 's/typedef int YYSTYPE;/typedef union { int i; char * str; } YYSTYPE;/' parser.y.c
	sed -i 's/typedef int YYSTYPE;/typedef union { int i; char * str; } YYSTYPE;/' parser.h
	gcc -c symboltable.c instructions.c
	gcc parser.y.c parser.l.c symboltable.o instructions.o -ly -ll -o parser
	@#rm -f symboltable.o instructions.o
	rm -f symboltable.o instructions.o parser.h *.l.c *.y.c

# compile a file
compile:
	@if [ ! -f ./parser ]; then\
		make compiler;\
	fi
	@#printf "\nParsed tokens :\n\n"
	@cat $(file).c | ./parser
	@mv output.s $(file).s
	@#printf "\nAssembly code generated :\n\n"
	@printf "Assembly code generated :\n\n"
	@cat $(file).s
	@printf "\n"

# build the interpreter
interpreter:
	gcc interpreter.c -o interpreter

# interprete a file
interprete:
	@if [ ! -f ./interpreter ]; then\
		make interpreter;\
	fi
	@./interpreter $(file).s

clean:
	@#rm -f *.l.c *.y.c *.s parser.h parser interpreter
	rm -f *.s parser interpreter

# note : @ prevents make from diplaying the command
