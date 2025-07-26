(* A executer dans une session "dune utop" *)

open Mycaml;;
open Mycaml__.AST;;

let p = parse "let x = 33";;
(* - : program = [SimpleDef (Id "x", Cst 33)] *)

eval p;;
(* - : (identifier * value) list = [(Id "x", VInt 33)] *)

let p = parse "let x = (+) 33 44 let y = (+) x x";;
eval p;;

let p = parse
"let rec fact n =
  match n with
    0 -> 1
  | _ -> ( * ) n (fact ((-) n 1))
  end
 let test = fact 10";;
eval p;;

let p = parse
"let rec size tree =
  match tree with
   Leaf() -> 0
  |Node(x,g,d) -> (+) 1 ((+) (size g) (size d))
 end
 let test = size (Node(1,Node(2,Leaf(),Leaf()),Leaf()))";;
eval p;;
