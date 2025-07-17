{
  exception Eof

(* pour connaître la position, ligne et colonne *)

  let current_position lexbuf =
    let open Lexing in
    let p = lexeme_start_p lexbuf in
    Printf.sprintf "line %i, column %i" p.pos_lnum (p.pos_cnum - p.pos_bol)





}

let espacement=[' ''\t']+ 
let newline='\n'|'\r'|"\r\n"

rule lexeur = parse
  | ['a'-'z''A'-'Z']+  as name {print_string (current_position lexbuf); print_string " ";  print_string (name); print_newline()}
  | espacement+  { print_newline()}
  | newline       { Lexing.new_line lexbuf; (* sert à mettre à jour le nombre de lignes pour la position*) lexeur lexbuf }
  | _           { lexeur lexbuf }
  | eof		{ raise Eof }

{
  let ch = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel ch in
  try
    while true do
      lexeur lexbuf
    done
  with Eof -> (print_newline(); print_newline())
}
