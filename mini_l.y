/* calculator. */
%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 FILE * yyin;
%}

%union{
  char* identval; 
  int ival;
}

%error-verbose
%start Program
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP BREAK READ WRITE AND OR NOT TRUE FALSE RETURN
%token SUB ADD MULT DIV MOD
%token EQ NEQ LT GT LTE GTE
%token <identval> IDENT
%token <ival> NUMBER
%token SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN


%% 
Program: Function Program {printf("Program -> Function Program\n");}
	| /*e*/ {printf ("Program -> Epsilon\n");}
;

Function: FUNCTION Identifier SEMICOLON BEGIN_PARAMS Declaration END_PARAMS BEGIN_LOCALS Declaration END_LOCALS BEGIN_BODY Statement END_BODY {printf("Function -> FUNCTION Identifier SEMICOLON BEGIN_PARAMS Declaration END_PARAMS BEGIN_LOCALS Declaration END_LOCALS BEGIN_BODY Statement END_BODY\n");}
;

Declaration: Declaration_Body SEMICOLON Declaration {printf("Declaration -> Declaration_Body SEMICOLON Declaration\n"); }
	| /*e*/ {printf("Declaration -> Epsilon\n"); }
;

Declaration_Body: Identifier COLON INTEGER {printf("Delcaration_Body -> Identifier COLON INTEGER\n");}
		| Identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("Declaration_body -> Identifier COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}
;

Identifier: IDENT {printf("Identifier -> IDENT %s\n", $1);}
	| IDENT COMMA Identifier {printf("Identifier -> IDENT COMMA Identifier\n");}
;

Statement: Statement Statement_Body SEMICOLON {printf("Statement -> Statement Statement_Body SEMICOLON\n");}
	| Statement_Body SEMICOLON {printf("Statement -> Statement_Body SEMICOLON\n");}
;

Statement_Body: Var ASSIGN Expression {printf("Statement_Body -> Var ASSIGN EXPRESSION\n");}
		| IF Bool_Exp THEN Statement ELSE Statement ENDIF {printf("Statement_Body -> IF Bool_Exp THEN Statement ELSE Statement ENDIF\n");}
		| IF Bool_Exp THEN Statement ENDIF {printf("Statement_Body -> IF Bool_Exp THEN Statement ENDIF\n");}
		| WHILE Bool_Exp BEGINLOOP Statement ENDLOOP {printf("Statement_Body -> WHILE Bool_Exp BEGINLOOP Statement ENDLOOP\n");}
		| DO BEGINLOOP Statement ENDLOOP WHILE Bool_Exp {printf("Statement_Body -> DO BEGINLOOP Statement ENDLOOP WHILE Bool_Exp\n");}
		| READ Var {printf("Statement_Body -> READ Var\n");}
		| WRITE Var {printf("Statement_Body -> WRITE Var\n");}
		| BREAK {printf("Statement_Body -> BREAK\n");}
		| RETURN Expression {printf("Statement_Body -> RETURN Expression\n");}
;


Bool_Exp: Relation_And_Expr {printf("Bool_Exp -> Relation_And_Expr\n");}
	| Relation_And_Expr OR Relation_And_Expr {printf("Bool_Exp -> Relation_And_Expr\n");}
;


Relation_And_Expr: Relation_Expr {printf("Relation_And_Expr -> Relation_Expr\n");}
		| Relation_Expr AND Relation_Expr {printf("Relation_And_Expr -> Relation_Expr AND Relation_Expr\n");}
;


Relation_Expr: NOT Relation_Expr_Body {printf("Relation_Expr -> NOT Relation_Expr_Body\n");}
		| Relation_Expr_Body {printf("Relation_Expr -> Relation_Expr_Body\n");}
;


Relation_Expr_Body: Expression Comp Expression {printf("Relation_Expr_Body -> Expression Comp Expression\n");}
		| TRUE {printf("Relation_Expr_Body -> TRUE\n");}
		| FALSE {printf("Relation_Expr_Body -> FALSE\n");}
		| L_PAREN Bool_Exp R_PAREN {printf("Relation_Expr_Body -> L_PAREN Bool_Exp R_PAREN\n");}
;


Comp: EQ {printf("Comp -> EQ\n");}
	| NEQ {printf("Comp -> NEQ\n");}
	| LT {printf("Comp -> LT\n");}
	| GT {printf("Comp -> GT\n");}
	| LTE {printf("Comp -> LTE\n");}
	| GTE {printf("Comp -> GTE\n");}
;


Expression: Expression_Body {printf("Expression -> Expression_Body\n");}
	| Expression COMMA Expression_Body {printf("Expression -> Expression COMMA Expression_Body\n");}
	| /*e*/ {printf("Expression -> Epsilon\n");}
;


Expression_Body: Mult_Expr {printf("Expression_Body -> Mult_Expr\n");}
		| Mult_Expr ADD Expression {printf("Expression_Body -> Mult_Expr ADD Expression\n");}
		| Mult_Expr SUB Expression {printf("Expression_Body -> Mult_Expr SUB Expression\n");}
;


Mult_Expr: Term {printf("Mult_Expr -> Term\n");}
	| Term MULT Mult_Expr {printf("Mult_Expr -> Term MULT Mult_Expr\n");}
	| Term DIV Mult_Expr {printf("Mult_Expr -> Term DIV Mult_Expr\n");}
	| Term MOD Mult_Expr {printf("Mult_Expr -> Term MOD Mult_Expr\n");}
;


Term: Term_Body {printf("Term -> Term_Body\n");}
	| SUB Term_Body {printf("Term -> SUB Term_Body\n");}
	| Identifier L_PAREN Expression R_PAREN {printf("Term -> Identifier L_PAREN Expression R_PAREN\n");}
;


Term_Body: Var {printf("Term_Body -> Var\n");}
	| NUMBER {printf("Term_Body -> NUMBER\n");}
	| L_PAREN Expression R_PAREN {printf("Term_Body -> L_PAREN Expression R_PAREN");}
;


Var: Identifier {printf("Var -> Identifier\n");}
	| Identifier L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {printf("Var -> Identifier L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");}

;
%%

/*
int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}*/

void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currPos, msg);
}
