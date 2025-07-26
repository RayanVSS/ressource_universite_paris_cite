open Ast

let lexbuf = Lexing.from_channel stdin 

let eval = function
  | Var _ -> false
  | True -> true
  | False -> false
  | _ -> failwith "A faire"
           
let ast = Parser.input Lexer.main lexbuf 

let _ = Printf.printf "Parse:\n%s\n" (Ast.as_string ast)
