%{
open Ast
%}

%token OR LPAREN RPAREN TRUE FALSE EOF
%token<string> ID 

%start<Ast.expression> input

%%

  
input: c=expression EOF { c }

expression:
x=ID  { Var x }
| l=expression OR r=expression { Or (l, r) }
| TRUE { True}
| FALSE { False }
| LPAREN c=expression RPAREN { c }

