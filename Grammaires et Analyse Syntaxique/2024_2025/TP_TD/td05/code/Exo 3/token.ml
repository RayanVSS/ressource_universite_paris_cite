type token = INT of int | RPAR | LPAR | PLUS | MINUS |  EOF

let string_of_token = function
    INT i -> "INT "^(string_of_int i)
  | RPAR -> ")"
  | LPAR -> "("  
  | PLUS -> "+"
  | MINUS -> "-"
  | EOF -> "EOF"


