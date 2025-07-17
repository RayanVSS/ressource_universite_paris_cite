{
open  Token
}
let layout = [ ' ' '\t' '\n' ]

let entier = ['0'-'9']+

rule lexeur = parse
 | layout		{ lexeur lexbuf }
  | ")"			{ RPAR }
  | "("			{ LPAR }
  | "+"                 { PLUS }
  | "-"		        { MINUS }
  | entier as i		{ INT (int_of_string i) }
  | eof			{ EOF }
  | _			{ failwith "unexpected character" }
