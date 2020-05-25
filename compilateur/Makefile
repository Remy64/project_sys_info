# default target, called by a simple "make"
all: compiler

# build the compiler
compiler:
	yacc -d compiler.y -o compiler.y.c
	lex -o compiler.l.c compiler.l
	sed -i 's/typedef int YYSTYPE;/typedef union { int i; char * str; } YYSTYPE;/' compiler.y.c
	sed -i 's/typedef int YYSTYPE;/typedef union { int i; char * str; } YYSTYPE;/' compiler.y.h
	gcc -c variables.c instructions.c
	gcc compiler.y.c compiler.l.c variables.o instructions.o -ly -ll -o compiler
	rm -f variables.o instructions.o *.l.c *.y.*

# compile a file
compile:
	@if [ ! -f ./compiler ]; then\
		make compiler;\
	fi
	@#printf "\nLexed tokens :\n\n"
	@cat $(file).c | ./compiler
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
	rm -f tests/*.s *.s compiler interpreter

# note : @ prevents make from diplaying the command
