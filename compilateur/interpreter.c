#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define VAR_TABLE_SIZE 300

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

typedef struct {
	Type type;
	int args[3];
} Instruction;

int vars[VAR_TABLE_SIZE];

void printInstruction(int addr, Instruction instr) {
    char name[4];
    switch(instr.type) {
        case ADD:
	case SOU:
	case MUL:
	case DIV:
	case INF:
	case SUP:
	case EQU:
            switch(instr.type) {
                case ADD:
                    strcpy(name, "ADD");
                    break;
                case SOU:
                    strcpy(name, "SOU");
                    break;
                case MUL:
                    strcpy(name, "MUL");
                    break;
                case DIV:
                    strcpy(name, "DIV");
                    break;
                case INF:
                    strcpy(name, "INF");
                    break;
                case SUP:
                    strcpy(name, "SUP");
                    break;
                case EQU:
                    strcpy(name, "EQU");
            }
            printf("%d\t%s\t%d\t%d\t%d\n", addr, name, instr.args[0], instr.args[1], instr.args[2]);
            break;
        case COP:
        case AFC:
        case JMF:
            switch(instr.type) {
                case COP:
                    strcpy(name, "COP");
                    break;
                case AFC:
                    strcpy(name, "AFC");
                    break;
                case JMF:
                    strcpy(name, "JMF");
            }
            printf("%d\t%s\t%d\t%d\n", addr, name, instr.args[0], instr.args[1]);
            break;
        case JMP:
        case PRI:
            switch(instr.type) {
                case JMP:
                    strcpy(name, "JMP");
                    break;
                case PRI:
                    strcpy(name, "PRI");
            }
            printf("%d\t%s\t%d\n", addr, name, instr.args[0]);
    }
}

int interpreteInstruction(Instruction instr) {
    switch(instr.type) {
        case ADD:
            vars[instr.args[0]] = vars[instr.args[1]] + vars[instr.args[2]];
            break;
        case SOU:
            vars[instr.args[0]] = vars[instr.args[1]] - vars[instr.args[2]];
            break;
        case MUL:
            vars[instr.args[0]] = vars[instr.args[1]] * vars[instr.args[2]];
            break;
        case DIV:
            vars[instr.args[0]] = vars[instr.args[1]] / vars[instr.args[2]];
            break;
        case INF:
            vars[instr.args[0]] = vars[instr.args[1]] < vars[instr.args[2]];
            break;
        case SUP:
            vars[instr.args[0]] = vars[instr.args[1]] > vars[instr.args[2]];
            break;
        case EQU:
            vars[instr.args[0]] = vars[instr.args[1]] == vars[instr.args[2]];
            break;
        case COP:
            vars[instr.args[0]] = vars[instr.args[1]];
            break;
        case AFC:
            vars[instr.args[0]] = instr.args[1];
            break;
        case JMF:
            if(!vars[instr.args[0]]) {
                return instr.args[1];
            }
            break;
        case JMP:
            return instr.args[0];
            break;
        case PRI:
            printf("Print : \"%d\"\n", vars[instr.args[0]]);
    }
    return -1;
}

int main(int argc, char * argv[]) {
    if(argc != 2) {
        fprintf(stderr, "Fatal Error : You have to provide exactly one argument : the name of the assembly file you want to interprete\n");
        exit(-1);
    }

    //file opening
    FILE * asmFile = fopen(argv[1], "r");
    if(asmFile == NULL) {
        fprintf(stderr, "Fatal Error : could not open the file given as a parameter\n");
        exit(-1);
    }

    int nbLinesMax = 50;
    int nbLinesMaxIncr = 20;
    Instruction * instructions = malloc(nbLinesMax * sizeof(Instruction));

    //file reading
    char * line = NULL; //the line buffer will be allocated by the getline function, and reallocated if its size is too small
    size_t maxLineSize = 0;
    ssize_t lineSize = 0;
    int nbLines;
    for(nbLines = 0; (lineSize = getline(&line, &maxLineSize, asmFile)) != -1; nbLines++) {
        if(nbLines == nbLinesMax) {
            nbLinesMax += nbLinesMaxIncr;
            instructions = realloc(instructions, nbLinesMax * sizeof(Instruction));
	}
        int args[3];
        char * iter = NULL;
        int i = 0;
        while((iter = strsep(&line, "\t")) != NULL && i < 4) {
            int length = strlen(iter);
            if(iter[length-1] == '\n') {
                iter[length-1] = '\0';
            }
            if(i == 0) {
                if (strcmp(iter, "ADD") == 0) {
                    instructions[nbLines].type = ADD;
                } else if (strcmp(iter, "SOU") == 0) {
                    instructions[nbLines].type = SOU;
                } else if (strcmp(iter, "MUL") == 0) {
                    instructions[nbLines].type = MUL;
                } else if (strcmp(iter, "DIV") == 0) {
                    instructions[nbLines].type = DIV;
                } else if (strcmp(iter, "INF") == 0) {
                    instructions[nbLines].type = INF;
                } else if (strcmp(iter, "SUP") == 0) {
                    instructions[nbLines].type = SUP;
                } else if (strcmp(iter, "EQU") == 0) {
                    instructions[nbLines].type = EQU;
                } else if (strcmp(iter, "COP") == 0) {
                    instructions[nbLines].type = COP;
                } else if (strcmp(iter, "AFC") == 0) {
                    instructions[nbLines].type = AFC;
                } else if (strcmp(iter, "JMF") == 0) {
                    instructions[nbLines].type = JMF;
                } else if (strcmp(iter, "JMP") == 0) {
                    instructions[nbLines].type = JMP;
                } else if (strcmp(iter, "PRI") == 0) {
                    instructions[nbLines].type = PRI;
                } else {
                    fprintf(stderr, "Fatal Error : \"%s\" is an unknown instruction\n", iter);
                    exit(-1);
		}
            } else {
                instructions[nbLines].args[i-1] = (int) strtol(iter, (char **) NULL, 10);
            }
            i++;
        }
    }
    free(line);

    //interpreter
    int i = 0;
    while(i < nbLines) {
        printInstruction(i, instructions[i]);
        int ret = interpreteInstruction(instructions[i]);
        if(ret == -1) {
            i++;
        } else {
            if(ret >= nbLines || ret < 0) {
                fprintf(stderr, "Fatal Error : jump to hyperspace (instruction address out of bounds) : \"%d\"\n", ret);
                exit(-1);
            }
            i = ret;
        }
    }

    free(instructions);
    fclose(asmFile);

    return 0;
}

