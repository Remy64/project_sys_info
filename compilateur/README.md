# Compiler and Interpreter

## C Compiler

To compile a file, use :

	"make compile file=<filepath>" (<filepath> does not include the ".c" extension)

To rebuild the compiler after modifying lex or yacc files, use :

	"make compiler" (or simply "make")


## Assembly Interpreter

To interprete the assembly file generated by the previous command, use :

	"make interprete file=<filepath>" (<filepath> does not include the ".s" extension)

To recompile the interpreter after modifying "interpreter.c", use :

	"make interpreter"

