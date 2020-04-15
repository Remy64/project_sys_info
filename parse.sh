#!/bin/bash

[ $# -ne 1 ] && echo "Error : You need to provide exactly one parameter : the name of the file you want to compile" && exit
[ ! -f ./parser ] && ./make.sh
printf "\nParsed tokens :\n\n"
cat ${1} | ./parser
file_name=`basename $1 .c`
mv output.s ${file_name}.s
printf "\nAssembly code generated :\n\n"
cat ${file_name}.s
printf "\n"
