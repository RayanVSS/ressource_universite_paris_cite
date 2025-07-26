type expression =
  | Var of string
  | True
  | False
  | Or of expression * expression

let rec as_string = function
  | Var x -> x
  | True -> "true"
  | False -> "false"
  | Or (l, r) -> apply "\\/" l r

and apply op l r = 
  "(" ^ as_string l ^ ") " ^ op ^ " (" ^ as_string r ^ ")"
