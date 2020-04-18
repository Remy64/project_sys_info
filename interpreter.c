#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define VAR_TABLE_SIZE 300

int vars[VAR_TABLE_SIZE];

void printInstruction(int numArgs, const char * instruction, int args[]) {
    switch(numArgs) {
        case 0:
            printf("%s\n", instruction);
            break;
        case 1:
            printf("%s\t%d\n", instruction, args[0]);
            break;
        case 2:
            printf("%s\t%d\t%d\n", instruction, args[0], args[1]);
            break;
        case 3:
            printf("%s\t%d\t%d\t%d\n", instruction, args[0], args[1], args[2]);
    }
}

void executeInstruction(const char * instruction, int args[]) {
    if (strcmp(instruction, "ADD") == 0) {
        vars[args[0]] = vars[args[1]] + vars[args[2]];
    } else if (strcmp(instruction, "SOU") == 0) {
        vars[args[0]] = vars[args[1]] - vars[args[2]];
    } else if (strcmp(instruction, "MUL") == 0) {
        vars[args[0]] = vars[args[1]] * vars[args[2]];
    } else if (strcmp(instruction, "DIV") == 0) {
        vars[args[0]] = vars[args[1]] / vars[args[2]];
    } else if (strcmp(instruction, "INF") == 0) {
        vars[args[0]] = vars[args[1]] < vars[args[2]];
    } else if (strcmp(instruction, "SUP") == 0) {
        vars[args[0]] = vars[args[1]] > vars[args[2]];
    } else if (strcmp(instruction, "EQU") == 0) {
        vars[args[0]] = vars[args[1]] == vars[args[2]];
    } else if (strcmp(instruction, "COP") == 0) {
        vars[args[0]] = vars[args[1]];
    } else if (strcmp(instruction, "AFC") == 0) {
        vars[args[0]] = args[1];
    } else if (strcmp(instruction, "JMF") == 0) {
        //TODO
    } else if (strcmp(instruction, "JMP") == 0) {
        //TODO
    } else if (strcmp(instruction, "PRI") == 0) {
        printf("Print : \"%d\"\n", vars[args[0]]);
    }
}

void interpreteLine(char * buffer) {
    char * instruction = NULL;
    int args[3];

    char * iter = NULL;
    int i = 0;
    while((iter = strsep(&buffer, "\t")) != NULL && i < 4) {
        int length = strlen(iter);
        if(iter[length-1] == '\n') {
            iter[length-1] = '\0';
        }

        if(i == 0) {
            instruction = iter;
        } else {
            args[i-1] = (int) strtol(iter, (char **) NULL, 10);
        }
        i++;
    }
    printInstruction(i-1, instruction, args);
    executeInstruction(instruction, args);
}

int main(int argc, char * argv[]) {
    if(argc != 2) {
        fprintf(stderr, "Fatal Error : You have to provide exactly one argument : the name of the assembly file you want to interprete");
        exit(-1);
    }

    FILE * asmFile = fopen(argv[1], "r");
    if(asmFile == NULL) {
        fprintf(stderr, "Fatal Error : could not open the file given as a parameter");
        exit(-1);
    }

    //initial buffer size
    //the buffer will be reallocated by the getline function if its size is too small
    size_t bufferSize = 50;
    char * buffer = malloc(bufferSize * sizeof(char));
    size_t read;
    while((read = getline(&buffer, &bufferSize, asmFile)) != -1) {
        interpreteLine(buffer); //we will probably have to store lines in a "char **" before interpreting them to handle "if" statements
    }
    free(buffer);
    return 0;
}
