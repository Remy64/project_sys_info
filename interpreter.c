#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void interpreteLine(char * buffer) {
    char * delim = "\t";
    char * iter = strtok(buffer, delim);

    while(iter != NULL) {
        printf("%s\t", iter);
        iter = strtok(NULL, delim);
    }
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
        interpreteLine(buffer);
    }
    free(buffer);
}