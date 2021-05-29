%{

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "cgen.h"
#include "myanalyzer.tab.h"

int line_num = 1;

%}

ID         [a-zA-Z_][0-9a-zA-Z_]*
DIGIT      [0-9]
DIGIT_POS  [1-9]
INTEGER    {DIGIT_POS}{DIGIT}*|{DIGIT}
DECIMAL    [+-]?{INTEGER}("."{INTEGER})?
REAL       {DECIMAL}([eE][+-]?{INTEGER})?
CHARACTER  [a-zA-Z0-9\-+\*\/:_$!#@&~^()., ]|[\\n]|[\\t]|[\\r]|[\\\\]|[\\\"]
STRING     \"{CHARACTER}*\"|\'{CHARACTER}*\'

%x comment

%%

int      return KEYWORD_INT;
real     return KEYWORD_REAL;
string   return KEYWORD_STRING;
bool     return KEYWORD_BOOL;
true     return KEYWORD_TRUE;
false    return KEYWORD_FALSE;
var      return KEYWORD_VAR;
const    return KEYWORD_CONST;
if       return KEYWORD_IF;
else     return KEYWORD_ELSE;
for      return KEYWORD_FOR;
while    return KEYWORD_WHILE;
break    return KEYWORD_BREAK;
continue return KEYWORD_CONTINUE;
func     return KEYWORD_FUNC;
nil      return KEYWORD_NIL;
and      return KEYWORD_AND;
or       return KEYWORD_OR;
not      return KEYWORD_NOT;
return   return KEYWORD_RETURN;
begin    return KEYWORD_BEGIN;


{ID}        { yylval.str = strdup(yytext);   return IDENTIFIER;}
{INTEGER}   { yylval.str = strdup(yytext);   return INTEGER;}
{REAL}      { yylval.str = strdup(yytext);   return REAL;}
{STRING}    { yylval.str = strdup(yytext);   return STRING;}

"+"          return '+';
"-"          return '-';
"*"          return '*';
"/"          return '/';
"%"          return '%';
"**"         return POWER_OP;
"=="         return EQUAL_OP;
"!="         return NOTEQUAL_OP;
"<"          return '<';
"<="         return LESSEQUAL_OP;
">"          return '>';
">="         return BIGGEREQUAL_OP;
"="          return '=';

";"          return ';';
"("		     return '(';
")"			 return ')';
","          return ',';
"["          return '[';
"]"          return ']';
"{"          return '{';
"}"          return '}';

[ \r\t]+		        /* ignore whitespace */

"/*"				    BEGIN(comment);
<comment>[^*\n]*        /* ignore anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* ignore '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        BEGIN(INITIAL);
"//"[^\n]*              /* line comments */

\n      ++line_num;

<<EOF>> return EOF;
.       {yyerror("Lexical error: unrecognized literal '%s in line %d'\n", yytext, line_num);}
 
%%


 
