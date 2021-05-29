%{
    #include <stdio.h>
    #include "cgen.h"
    extern int yylex(void);
    extern int lineNum;
%}

%union{
    char* str;
}

%token <str> IDENTIFIER
%token <str> REAL
%token <str> STRING
%token <str> INTEGER
%token <str> KEYWORD_INT
%token <str> KEYWORD_REAL
%token <str> KEYWORD_STRING
%token <str> KEYWORD_BOOL
%token <str> KEYWORD_TRUE
%token <str> KEYWORD_FALSE
%token <str> KEYWORD_VAR
%token <str> KEYWORD_CONST
%token <str> KEYWORD_IF
%token <str> KEYWORD_ELSE
%token <str> KEYWORD_FOR
%token <str> KEYWORD_WHILE
%token <str> KEYWORD_BREAK
%token <str> KEYWORD_CONTINUE
%token <str> KEYWORD_FUNC
%token <str> KEYWORD_NIL
%token <str> KEYWORD_AND
%token <str> KEYWORD_OR
%token <str> KEYWORD_NOT
%token <str> KEYWORD_RETURN
%token <str> KEYWORD_BEGIN
%token <str> POWER_OP
%token <str> EQUAL_OP
%token <str> NOTEQUAL_OP
%token <str> LESSEQUAL_OP
%token <str> BIGGEREQUAL_OP
%token <str> LOWERT
%nonassoc LOWERT
%nonassoc KEYWORD_ELSE
%type <str> program_body
%type <str> stmt
%type <str> arrays
%type <str> expressions
%type <str> var
%type <str> datatype
%type <str> const
%type <str> instruction
%type <str> assignment_instruction
%type <str> instruction_block
%type <str> func_call_arguments
%type <str> func_declare
%type <str> var_assignment
%type <str> data
%type <str> assignment
%type <str> func_arguments
%type <str> func_body
%type <str> func_call
%type <str> multiple_instructions
%type <str> func_begin

%start begin

%left KEYWORD_OR
%left KEYWORD_AND
%left EQUAL_OP NOTEQUAL_OP '<' LESSEQUAL_OP '>' BIGGEREQUAL_OP
%left '-' '+'
%left '*' '/' '%'
%right POWER_OP
%right SIGN_OP
%right KEYWORD_NOT


%%
begin: program_body
  {
     if (yyerror_count == 0) {
	    puts("#include <stdio.h>");
		puts("#include <stdlib.h>");
	    puts("#include <math.h>");
        puts(c_prologue);
        printf("%s\n", $1);
     }
 };

program_body:
 %empty                      {$$ = template("\n");}
 |program_body const         {$$ = template("%s%s", $1, $2);}
 |program_body var           {$$ = template("%s%s", $1, $2);}
 |program_body func_declare  {$$ = template("%s%s", $1, $2);}
 |program_body func_begin    {$$ = template("%s%s", $1, $2);}
 ;

 
const:
  KEYWORD_CONST assignment datatype ';' {$$ = template("const %s %s;\n", $3, $2);}
 ;

var:
  KEYWORD_VAR var_assignment datatype ';'   {$$ = template("%s %s;\n",$3,$2);} 
 |KEYWORD_VAR arrays ';'                    {$$ = template("%s",$2);}
 ;

var_assignment:
  IDENTIFIER                                 	{$$ = $1;}
 |IDENTIFIER '=' expressions                 	{$$ = template("%s = %s", $1, $3);}
 |IDENTIFIER ',' var_assignment                 {$$ = template("%s , %s", $1, $3);}
 |IDENTIFIER '=' expressions ',' var_assignment {$$ = template("%s = %s , %s", $1, $3, $5);}
 ;

arrays:
  IDENTIFIER '[' INTEGER ']'datatype        {$$ = template("%s %s[%s];\n",$5,$1,$3);}
 |IDENTIFIER '[' ']'datatype                {$$ = template("%s* %s;\n", $4, $1);}
 ;

assignment:
  IDENTIFIER '=' expressions                    {$$ = template("%s = %s", $1, $3);}
 |IDENTIFIER '=' expressions ',' assignment   	{$$ = template("%s = %s, %s", $1, $3, $5);}
 ;
 
datatype:
  KEYWORD_REAL                          {$$ = template("double");}
 |KEYWORD_INT                           {$$ = template("int");}
 |KEYWORD_STRING                        {$$ = template("char*");}
 |KEYWORD_BOOL                          {$$ = template("int");}
 ;

func_declare:
  KEYWORD_FUNC IDENTIFIER '(' func_arguments ')' datatype '{' func_body '}' ';'         {$$ = template("%s %s (%s) {\n%s};\n", $6, $2, $4, $8);}
 |KEYWORD_FUNC IDENTIFIER '(' func_arguments ')' '[' ']' datatype '{' func_body '}' ';' {$$ = template("%s* %s (%s) {\n%s};\n", $8, $2, $4, $10);}
 |KEYWORD_FUNC IDENTIFIER '(' func_arguments ')' '{' func_body '}' ';'                  {$$ = template("void %s (%s) {\n%s};\n", $2, $4, $7);}
 |KEYWORD_FUNC IDENTIFIER '(' ')' datatype '{' func_body '}' ';'                    	{$$ = template("%s %s () {\n%s};\n", $5, $2, $7);}
 |KEYWORD_FUNC IDENTIFIER '(' ')' '[' ']' datatype '{' func_body '}' ';'            	{$$ = template("%s* %s () {\n%s};\n", $7, $2, $9);}
 ;
 
func_arguments:
  IDENTIFIER datatype                        	 {$$ = template("%s %s", $2, $1);}
 |IDENTIFIER '['']' datatype                 	 {$$ = template("%s* %s", $4, $1);}
 |IDENTIFIER datatype ',' func_arguments         {$$ = template("%s %s, %s",$2, $1, $4);}
 |IDENTIFIER '['']' datatype ',' func_arguments  {$$ = template("%s* %s, %s",$4, $1, $6);} 
 ;
 
func_body: 
  var func_body               {$$ = template("%s%s", $1, $2);}
 |const func_body             {$$ = template("%s%s", $1, $2);}
 |instruction func_body       {$$ = template("%s%s", $1, $2);}
 |%empty                      {$$ = template("");}
 ;

func_call_arguments:
 %empty                					 {$$ = template("");}
 |expressions ',' func_call_arguments    {$$ = template("%s, %s", $1, $3);}
 |expressions                   		 {$$ = $1;}
 ;

func_call:
  IDENTIFIER '(' func_call_arguments ')' {$$ = template("%s(%s)", $1, $3);}
 ;

func_begin:
  KEYWORD_FUNC KEYWORD_BEGIN '(' ')' '{' func_body '}' ';' {$$ = template("int main() {\n%s}\n", $6);}
 ;
 
expressions:
  KEYWORD_NOT expressions            		{$$ = template("NOT %s", $2);}
 |'+' expressions %prec SIGN_OP      		{$$ = template("+%s", $2);}
 |'-' expressions %prec SIGN_OP      		{$$ = template("-%s", $2);}
 |expressions POWER_OP expressions          {$$ = template("pow(%s, %s)", $1, $3);}
 |expressions '*' expressions               {$$ = template("%s * %s", $1, $3);}
 |expressions '/' expressions               {$$ = template("%s / %s", $1, $3);}
 |expressions '%' expressions               {$$ = template("fmod(%s, %s)", $1, $3);}
 |expressions '+' expressions               {$$ = template("%s + %s", $1, $3);}
 |expressions '-' expressions               {$$ = template("%s - %s", $1, $3);}
 |expressions EQUAL_OP expressions          {$$ = template("%s == %s", $1, $3);}
 |expressions NOTEQUAL_OP expressions       {$$ = template("%s != %s", $1, $3);}
 |expressions '<' expressions               {$$ = template("%s < %s", $1, $3);}
 |expressions LESSEQUAL_OP expressions      {$$ = template("%s <= %s", $1, $3);}
 |expressions '>' expressions               {$$ = template("%s > %s", $1, $3);}
 |expressions BIGGEREQUAL_OP expressions    {$$ = template("%s >= %s", $1, $3);}
 |expressions KEYWORD_AND expressions       {$$ = template("%s && %s", $1, $3);}
 |expressions KEYWORD_OR expressions        {$$ = template("%s | %s", $1, $3);}
 |'('expressions')'                  		{$$ = template("(%s)", $2);} 
 |func_call                   				{$$ = $1;}
 |data                    				    {$$ = $1;}
 |IDENTIFIER                  				{$$ = $1;}
 |IDENTIFIER '[' INTEGER ']'     			{$$ = template("%s[%s]", $1, $3);}
 |IDENTIFIER '[' IDENTIFIER ']'             {$$ = template("%s[%s]", $1, $3);}
 |IDENTIFIER '[' IDENTIFIER '+' INTEGER ']' {$$ = template("%s[%s + %s]", $1, $3, $5);}
 |IDENTIFIER '[' IDENTIFIER '-' INTEGER ']' {$$ = template("%s[%s - %s]", $1, $3, $5);}
 |IDENTIFIER '[' IDENTIFIER '*' INTEGER ']' {$$ = template("%s[%s * %s]", $1, $3, $5);}
 |IDENTIFIER '[' IDENTIFIER '/' INTEGER ']' {$$ = template("%s[%s / %s]", $1, $3, $5);}
 |IDENTIFIER '[' INTEGER '+' IDENTIFIER ']' {$$ = template("%s[%s + %s]", $1, $3, $5);}
 |IDENTIFIER '[' INTEGER '-' IDENTIFIER ']' {$$ = template("%s[%s - %s]", $1, $3, $5);}
 |IDENTIFIER '[' INTEGER '*' IDENTIFIER ']' {$$ = template("%s[%s * %s]", $1, $3, $5);}
 |IDENTIFIER '[' INTEGER '/' IDENTIFIER ']' {$$ = template("%s[%s / %s]", $1, $3, $5);}
 ;

data:
  STRING          {$$ = $1;}
 |INTEGER         {$$ = $1;}
 |REAL            {$$ = $1;}
 |KEYWORD_FALSE   {$$ = template("0");}
 |KEYWORD_TRUE    {$$ = template("1");}
 |KEYWORD_NIL     {$$ = template("nil");}
 ;

instruction:
  assignment_instruction ';'  {$$ = template("%s;\n", $1);}
 |KEYWORD_IF '(' expressions ')' stmt %prec LOWERT                 			      			       {$$ = template("if (%s) %s\n", $3, $5);}
 |KEYWORD_IF '(' expressions ')' stmt KEYWORD_ELSE  stmt                                    	   {$$ = template("if (%s) %s else %s\n", $3, $5, $7);}
 |KEYWORD_FOR '(' assignment_instruction ';' assignment_instruction ')' stmt            		   {$$ = template("for (%s ; %s ; %s) %s\n", $3, $5, $7);}
 |KEYWORD_FOR '(' assignment_instruction ';' expressions ';' assignment_instruction ')' stmt       {$$ = template("for (%s ; %s ; %s) %s\n", $3, $5, $7, $9);}
 |KEYWORD_WHILE '(' expressions ')' stmt ';'                          					           {$$ = template("while ( %s ) %s\n", $3, $5);}
 |KEYWORD_BREAK ';'                                                   					  		   {$$ = template("break;\n");}
 |KEYWORD_CONTINUE ';'                                              					  		   {$$ = template("continue;\n");}
 |KEYWORD_RETURN ';'                                                					  		   {$$ = template("return;\n");}
 |KEYWORD_RETURN expressions ';'                                           					       {$$ = template("return %s;\n", $2);}
 |func_call ';'                                                     					  		   {$$ = template("%s;\n", $1);}
 ;

stmt:
  instruction         {$$ = template("{\n%s\n}", $1);}
 |instruction_block   {$$ = $1;}
 ;
 

multiple_instructions:
  instruction                  		{$$ = $1;}
 |instruction multiple_instructions {$$ = template("%s %s", $1, $2);}
 ;

instruction_block:
  '{' multiple_instructions '}'     {$$ = template("{\n%s\n}", $2);}
 ;

// Assignment Instruction
assignment_instruction:
  IDENTIFIER '=' expressions   									{$$ = template("%s = %s", $1, $3);}
 |IDENTIFIER '[' INTEGER ']' '=' expressions 					{$$ = template("%s[%s] = %s", $1, $3, $6);}  
 |IDENTIFIER '[' IDENTIFIER '+' INTEGER ']' '=' expressions 	{$$ = template("%s[%s + %s] = %s", $1, $3, $5, $8);}
 |IDENTIFIER '[' IDENTIFIER '-' INTEGER ']' '=' expressions 	{$$ = template("%s[%s - %s] = %s", $1, $3, $5, $8);}
 |IDENTIFIER '[' IDENTIFIER '*' INTEGER ']' '=' expressions 	{$$ = template("%s[%s * %s] = %s", $1, $3, $5, $8);}
 |IDENTIFIER '[' IDENTIFIER '/' INTEGER ']' '=' expressions 	{$$ = template("%s[%s / %s] = %s", $1, $3, $5, $8);}
 |IDENTIFIER '[' INTEGER '+' IDENTIFIER ']' '=' expressions 	{$$ = template("%s[%s + %s] = %s", $1, $3, $5, $8);}
 |IDENTIFIER '[' INTEGER '-' IDENTIFIER ']' '=' expressions 	{$$ = template("%s[%s - %s] = %s", $1, $3, $5, $8);}
 |IDENTIFIER '[' INTEGER '*' IDENTIFIER ']' '=' expressions 	{$$ = template("%s[%s * %s] = %s", $1, $3, $5, $8);}
 |IDENTIFIER '[' INTEGER '/' IDENTIFIER ']' '=' expressions 	{$$ = template("%s[%s / %s] = %s", $1, $3, $5, $8);}
 |IDENTIFIER '[' IDENTIFIER ']' '=' expressions 				{$$ = template("%s[%s] = %s", $1, $3, $6);}
 ;



%%
int main(){
    if (yyparse() == 0)
        printf("/*Correct!*/\n");
    else{
        printf("/*Not Correct!*/\n");
    }
}