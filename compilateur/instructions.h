#ifndef INSTRUCTIONS_H
#define INSTRUCTIONS_H

#define NB_MAX_INSTR 1000 //increase if necessary
#define INSTR_MAX_SIZE 100 //idem
#define NONE -1

typedef enum {
	ADD,
	SOU,
	MUL,
	DIV,
	INF,
	SUP,
	EQU,
	COP,
	AFC,
	JMF,
	JMP,
	PRI
} Type;


// adds an instructions to the instructions buffer
// note : use NONE when an argument is not needed for readability reasons
void instruction(Type type, int arg1, int arg2, int arg3);

// print the instructions found in the instructions buffer
void printInstructions();

#endif //INSTRUCTIONS_H

