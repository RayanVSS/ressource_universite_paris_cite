
let ch = open_in (Sys.argv.(1)) in
let lexbuf = Lexing.from_channel ch in
let somme = ref 0 in 
  let rec f (t:Token.token ) =
    match t with
    | DIGIT i -> print_int(i); somme := !somme + i ; f (Lexeur2.lexeur lexbuf)
    | OTHER -> f (Lexeur2.lexeur lexbuf)
    | EOF -> print_newline(); print_int !somme; print_newline()
  in
  f (Lexeur2.lexeur lexbuf);;
