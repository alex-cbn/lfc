%{
	#include "y.tab.h"

	int lineNo = 1;
	int colNo = 1;
%}

%%
"program" {colNo+=7; return TOK_PROGRAM;}
"+"		{ colNo++; return TOK_PLUS; }
"-"		{ colNo++; return TOK_MINUS; }
"*"		{ colNo++; return TOK_MULTIPLY; }
"/"		{ colNo++; return TOK_DIVIDE; }
"("		{ colNo++; return TOK_LEFT; }
")"		{ colNo++; return TOK_RIGHT; }
";"		{ colNo++; return ';'; }
"="		{ colNo++; return '='; }
"!="	{colNo+=2; return TOK_NEQ;}
"=="	{colNo++; return TOK_EQU;}
">"		{colNo++; return TOK_GTR;}
"<"		{colNo++; return TOK_LSS;}
"<="	{colNo+=2; return TOK_LEQ;}
">="	{colNo+=2; return TOK_GEQ;}
0|[1-9][0-9]*	{ yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.val_int = atoi(yytext); return TOK_INT_VALUE; }
[-+]?[0-9]*\.[0-9]+ {yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.val_float = atof(yytext); return TOK_FLOAT_VALUE; }
"True"		{colNo+=4; yylval.val_bool = true; return TOK_TRUE;}
"False"		{colNo+=5; yylval.val_bool = false; return TOK_FALSE;}
["].*["]	{yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.val_string = new char[strlen(yytext)+1]; strcpy(yylval.val_string,yytext); return TOK_STRING_VALUE;}
"begin"		{colNo+=5; return TOK_BEGIN;}
"end" 		{colNo+=3; return TOK_END;}
"repeat" 	{colNo+=6; return TOK_REPEAT;}
"until" 	{colNo+=5; return TOK_UNTIL;}
"if" 		{colNo+=2; return TOK_IF;}
"else" 		{colNo+=4; return TOK_ELSE;}
"then"		{colNo+=4; return TOK_THEN;}
int|float|boolean|string {if(strcmp(yytext, "int")==0){colNo+=3; yylval.val_int = 2; return TOK_DATA_TYPE;}if(strcmp(yytext, "float")==0){colNo+=5; yylval.val_int = 1; return TOK_DATA_TYPE;}if(strcmp(yytext, "boolean")==0){colNo+=7; yylval.val_int = 0; return TOK_DATA_TYPE;}	if(strcmp(yytext, "string")==0)	{colNo+=6; yylval.val_int = 3; return TOK_DATA_TYPE;}}
"print"		{ colNo+=5; return TOK_PRINT; }
[a-zA-Z][a-zA-Z0-9]* { yylloc.first_line = lineNo; yylloc.first_column = colNo; colNo+=strlen(yytext); yylval.name = new char[strlen(yytext)+1]; strcpy(yylval.name,yytext); return TOK_VARIABLE;}
[ ]		{ colNo++; }
.		{ colNo++; return TOK_ERROR; }
\n		{ lineNo++; colNo=1; }
%%
