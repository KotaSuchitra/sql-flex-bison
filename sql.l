%{
#include "sql.tab.h"
#include <string.h>
%}

%%
"SELECT"            { return SELECT; }
"FROM"              { return FROM; }
"WHERE"             { return WHERE; }
"="                 { return EQ; }
";"                 { return SEMICOLON; }

[a-zA-Z_][a-zA-Z0-9_]*    { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+                    { yylval.num = atoi(yytext); return NUMBER; }

[ \t\n\r]+         ;     // skip whitespace
.                  { printf("Unknown char: %s\n", yytext); }

%%
int yywrap() { return 1; }
