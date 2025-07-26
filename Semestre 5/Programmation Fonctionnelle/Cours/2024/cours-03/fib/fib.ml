
(* Exemple d'usage de la bibliothèque zarith pour calculer avec
   de très gros nombres en OCaml. Voir https://github.com/ocaml/Zarith

   Fichier à compiler via : ocamlopt -I +zarith zarith.cmxa fib.ml -o fib
   A condition que zarith soit bien installé (sudo apt install libzarith-ocaml-dev)

   Ou bien utiliser un outil d'automatisation de la compilation comme dune:
    dune build ./fib.exe
   Exemple de lancement dans ce cas:
    dune exec ./fib.exe -- -opt 1000
*)

let rec fib_naif n = match n with
  | 0 -> Z.zero
  | 1 -> Z.one
  | n -> Z.add (fib_naif (n-2)) (fib_naif (n-1))

let rec fib_paire n =
  if n = 0 then (Z.zero, Z.one)
  else
    let (a,b) = fib_paire (n-1) in
    (b, Z.add a b)

let fib_opt n = fst (fib_paire n)

let rec fib_loop n a b =
  if n = 0 then a
  else fib_loop (n-1) b (Z.add a b)

let fib_tailrec n = fib_loop n Z.zero Z.one

type matrix22 = (Z.t * Z.t) * (Z.t * Z.t)

let id = ((Z.one,Z.zero),(Z.zero,Z.one))

let mult_mat ((a,b),(c,d)) ((a',b'),(c',d')) =
  let ( + ) = Z.add in
  let ( * ) = Z.mul in
  ((a*a'+b*c', a*b' + b*d'),(c*a'+d*c', c*b' + d*d'))

let rec power_mat a n =
  if n = 0 then id
  else
    let b = power_mat a (n/2) in
    if n mod 2 = 0 then
      mult_mat b b
    else
      mult_mat a (mult_mat b b)

let fib_mat n =
  let a = ((Z.one,Z.one),(Z.one,Z.zero)) in
  let b = power_mat a n in
  snd (fst b)

let main =
  if Array.length Sys.argv < 3 then
    print_string "usage: fib (-naif|-opt|-tail|-matrix) n\n"
  else
    let n = int_of_string Sys.argv.(2) in
    let f =
      match Sys.argv.(1) with
      | "-opt" -> fib_opt
      | "-tail" -> fib_tailrec
      | "-matrix" -> fib_mat
      | _ -> fib_naif
    in
    Z.print (f n); print_newline ()
