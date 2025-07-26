(* A compiler soit manuellement (après installation de la librairie graphics)
   via : ocamlopt -I +graphics graphics.cmxa cercles.ml -o cercles

   Ou bien utiliser dune :
     dune build ./cercles.exe
     dune exec ./cercles.exe
   Ou encore pour fournir une option de ligne de commande (cf. Sys.argv)
     dune exec ./cercles.exe -- 10
*)

open Graphics

(* Des caractères '0'..'9' vers les entiers 0..9 *)
let char2int c = int_of_string (String.make 1 c)

(* Des caractères vers quelques couleurs *)
let char2color = function 'r' -> red | 'g' -> green | _ -> black

let rec loop t =
  let ev = wait_next_event [Mouse_motion;Key_pressed] in
  match ev.key with
  | _ when not ev.keypressed -> fill_circle ev.mouse_x ev.mouse_y t; loop t
  | ('r'|'g'|'b') as c -> set_color (char2color c); loop t
  | 'q'  -> () (* arret *)
  | '0'..'9' as c -> loop (char2int c)
  | _    -> loop t

let main =
  let width = try int_of_string Sys.argv.(1) with _ -> 5 in
  open_graph " 500x500"; loop width; close_graph ()
