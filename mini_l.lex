%{
  int currPos = 0;
  int currLine = 1;
  #include "y.tab.h"
%}

DIGIT   [0-9]
LETTERS [A-Za-z]
IDENTIFIER {LETTERS}|({LETTERS}+({LETTERS}|{DIGIT}|[_])*({LETTERS}|{DIGIT}))
WHITESPACE [ \t]+
NEWLINE [\n]
INVALID_ID_START_NUMBER {DIGIT}+{IDENTIFIER}
INVALID_ID_END_UNDERSCORE {IDENTIFIER}"_"+
INVALID_ID_START_UNDERSCORE "_"+{IDENTIFIER}

%%

"function" {currPos += yyleng; return FUNCTION;}
"beginparams" {currPos += yyleng; return BEGIN_PARAMS;}
"endparams" {currPos += yyleng; return END_PARAMS;}
"beginlocals" {currPos += yyleng; return BEGIN_LOCALS;}
"endlocals" {currPos += yyleng; return END_LOCALS;}
"beginbody" {currPos += yyleng; return BEGIN_BODY;}
"endbody" {currPos += yyleng; return END_BODY;}
"integer" {currPos += yyleng; return INTEGER;}
"array" {currPos += yyleng; return ARRAY;}
"of" {currPos += yyleng; return OF;}
"if" {currPos += yyleng; return IF;}
"then" {currPos += yyleng; return THEN;}
"endif" {currPos += yyleng; return ENDIF;}
"else" {currPos += yyleng; return ELSE;}
"while" {currPos += yyleng; return WHILE;}
"do" {currPos += yyleng; return DO;}
"beginloop" {currPos += yyleng; return BEGINLOOP;}
"endloop" {currPos += yyleng; return ENDLOOP;}
"break" {currPos += yyleng; return BREAK;}
"read" {currPos += yyleng; return READ;}
"write" {currPos += yyleng; return WRITE;}
"and" {currPos += yyleng; return AND;}
"or" {currPos += yyleng; return OR;}
"not" {currPos += yyleng; return NOT;}
"true" {currPos += yyleng; return TRUE;}
"false" {currPos += yyleng; return FALSE;}
"return" {currPos += yyleng; return RETURN;}

"-" {currPos += yyleng; return SUB;}
"+" {currPos += yyleng; return ADD;}
"*" {currPos += yyleng; return MULT;}
"/" {currPos += yyleng; return DIV;}
"%" {currPos += yyleng; return MOD;}
"==" {currPos += yyleng; return EQ;}
"<>" {currPos += yyleng; return NEQ;}
"<" {currPos += yyleng; return LT;}
">" {currPos += yyleng; return GT;}
"<=" {currPos += yyleng; return LTE;}
">=" {currPos += yyleng; return GTE;}

{IDENTIFIER} {currPos += yyleng; yylval.identval = yytext; return IDENT;}
{DIGIT}+ {currPos += yyleng; yylval.ival = atoi(yytext); return NUMBER;}
{WHITESPACE} {currPos += yyleng;}
{NEWLINE} {currLine += 1; currPos = 0;}
{INVALID_ID_START_NUMBER} {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currPos, yytext); exit(0);}
{INVALID_ID_END_UNDERSCORE} {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}
{INVALID_ID_START_UNDERSCORE} {printf("Error at line %d, column %d: identifier \"%s\" cannot start with an underscore\n", currLine, currPos, yytext); exit(0);}


";" {currPos += yyleng; return SEMICOLON;}
":" {currPos += yyleng; return COLON;}
"," {currPos += yyleng; return COMMA;}
"(" {currPos += yyleng; return L_PAREN;}
")" {currPos += yyleng; return R_PAREN;}
"[" {currPos += yyleng; return L_SQUARE_BRACKET;}
"]" {currPos += yyleng; return R_SQUARE_BRACKET;}
":=" {currPos += yyleng; return ASSIGN;}
"##".*\n {currPos = 0; currLine += 1;}

. {printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext); exit(0);}

%%

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}


/*
int main (int argc, char ** argv) { 
  yylex();

}*/
