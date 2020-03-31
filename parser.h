/* A Bison parser, made by GNU Bison 3.3.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2019 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tAFF = 258,
    tEQ = 259,
    tDIF = 260,
    tSINF = 261,
    tSSUP = 262,
    tINF = 263,
    tSUP = 264,
    tPLUS = 265,
    tMINUS = 266,
    tMUL = 267,
    tDIV = 268,
    tNOT = 269,
    tCB = 270,
    tOB = 271,
    tOC = 272,
    tCC = 273,
    tOH = 274,
    tCH = 275,
    tINT = 276,
    tVOID = 277,
    tCHAR = 278,
    tFLOAT = 279,
    tSPACE = 280,
    tTAB = 281,
    tNL = 282,
    tBS = 283,
    tSC = 284,
    tPRINTF = 285,
    tMAIN = 286,
    tNAME = 287,
    tINT_VAL = 288,
    tFLOAT_VAL = 289,
    tCHAR_VAL = 290,
    tRETURN = 291
  };
#endif
/* Tokens.  */
#define tAFF 258
#define tEQ 259
#define tDIF 260
#define tSINF 261
#define tSSUP 262
#define tINF 263
#define tSUP 264
#define tPLUS 265
#define tMINUS 266
#define tMUL 267
#define tDIV 268
#define tNOT 269
#define tCB 270
#define tOB 271
#define tOC 272
#define tCC 273
#define tOH 274
#define tCH 275
#define tINT 276
#define tVOID 277
#define tCHAR 278
#define tFLOAT 279
#define tSPACE 280
#define tTAB 281
#define tNL 282
#define tBS 283
#define tSC 284
#define tPRINTF 285
#define tMAIN 286
#define tNAME 287
#define tINT_VAL 288
#define tFLOAT_VAL 289
#define tCHAR_VAL 290
#define tRETURN 291

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union { float x; int i; char * str; char c; } YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
