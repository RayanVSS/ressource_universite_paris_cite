(* #### Elements de correction pour l'examen PF5 de janvier 2021 #### *)

(* Attention, dans les exercices 2 et 3, il y avait souvent
   plusieurs réponses correctes possibles, ce qui suit est
   une de ces réponses (a priori la plus simple) *)

(* Exercice 1 *)
(* Pour une correction, il suffit de taper les phrases suivantes
   dans un "toplevel" OCaml *)

1.0 +. (0 * 5.1) ;;
(*
  1.0 +. (0 * 5.1);;
              ^^^
Error: This expression has type float but an expression was expected of type int
*)

if true then if false then false else true else false ;;
(* - : bool = true *)

(fun x y -> x*(x+y)) 2 3 ;;
(* - : int = 10 *)

(fun x y -> x*(x+y)) 2 ;;
(* - : int -> int = <fun> *)

(fun x y -> x*(x+y)) 2 3 4 ;;
(*
  (fun x y -> x*(x+y)) 2 3 4;;
  ^^^^^^^^^^^^^^^^^^^^
Error: This function has type int -> int -> int
       It is applied to too many arguments; maybe you forgot a `;'.
 *)

let x = 2*2 in let x = x*x in x ;;
(* - : int = 16 *)

List.map (fun x -> x*x) [1; 2; 3] ;;
(* - : int list = [1; 4; 9] *)

List.map (fun x y -> x*y) [1; 2; 3] ;;
(* - : (int -> int) list = [<fun>; <fun>; <fun>]
Note : oui cet exemple est bien accepté !
List.map attend une function à un argument (rappel
List.map : ('a->'b)->'a list -> 'b list) mais une
fonction à deux arguments comme (fun x y -> x*y)
est en particulier une fonction à un argument ...
renvoyant en résultat une autre fonction attendant
l'argument restant. Autrement dit:
 int->int->int = int->(int->int)
Dans la liste des fonctions int->int produites,
la première est la multiplication par 1, la seconde
c'est (( * ) 2), la troisième c'est (( * ) 3)
(ces détails n'étaient pas demandés).
*)

if 1 < 2 then 42 else raise Not_found ;;
(* - : int = 42 *)

let r = ref 42 in r := !r + !r; !r ;;
(* - : int = 84 *)

(* Exercice 2 *)

let rec repeat n a =
  if n = 0 then [] else a :: repeat (n-1) a

let rec decode = function
  | [] -> []
  | (a,n) :: l -> repeat n a @ decode l

(* Version bonus (écrit de façon récursive terminale) *)

let decode l =
  let rec loop acc = function
    | [] -> List.rev acc
    | (a,0) :: l -> loop acc l
    | (a,n) :: l -> loop (a::acc) ((a,n-1) :: l)
  in
  loop [] l

(* Q2.2 *)

let add a n l = match l with
  | (b,m)::l' when a=b -> (a,n+m)::l'
  | l' -> if n=0 then l' else (a,n)::l'

(* Q2.3 *)

let rec encode = function
  | [] -> []
  | a::l -> add a 1 (encode l)

(* test *)
let _ = encode ['a';'a';'b';'c';'c';'c';'a';'a']
let _ = encode [1;1;2;2;2;3]

(* Q2.4 *)

let rec code_map f = function
  | [] -> []
  | (a,n)::l -> add (f a) n (code_map f l)

(* Exercice 3 *)

type 'a tree =
 | Node of 'a tree * 'a * 'a tree
 | Leaf

type pos = int

(* Q3.1 *)

let rec find n t = match t with
  | Leaf -> None
  | Node (g,v,d) ->
     if n=1 then Some v
     else if n mod 2 = 0 then find (n / 2) g else find (n / 2) d

type patricia = bool tree

(* Q3.2 *)
let mem n t = (find n t = Some true)

(* Q3.3 *)
let rec add n t = match t with
  | Node (g, b, d) ->
     if n = 1 then Node (g, true, d)
     else if n mod 2 = 0 then Node (add (n / 2) g, b, d)
     else Node (g, b, add (n / 2) d)
  | Leaf -> add n (Node (Leaf, false, Leaf))
          (* astuce permettant d'éviter d'écrire
             trois lignes ressemblant beaucoup au cas "Node"
             ci-dessus *)

(* Q3.4 *)

let rec of_list = function
  | [] -> Leaf
  | n::l -> add n (of_list l)

(* ou bien *)
let of_list l = List.fold_right add l Leaf

(* test *)
let _ = of_list [7;2];;

(* Q3.5 *)

let rec union a1 a2 = match (a1,a2) with
  | Leaf, _ -> a2
  | _, Leaf -> a1
  | Node (g1, b1, d1), Node (g2, b2, d2) ->
      Node (union g1 g2, b1 || b2, union d1 d2)

(* test *)
let _ = union (of_list [2]) (of_list [7]);;

(* Q3.6 *)

let rec to_list = function
  | Leaf -> []
  | Node (g,b,d) ->
    (if b then [1] else [])
    @ List.map (fun x -> 2*x) (to_list g)
    @ List.map (fun x -> 2*x+1) (to_list d)

(* test *)
let _ = to_list (of_list [2;7]);;
let _ = to_list (of_list [6]);;
let _ = to_list (of_list [5]);;

(* Attention, pas de codage récursif terminal juste en passant
   une position en argument avec (2*p) ou (2*p+1) à chaque
   appel récursif. Cela ne donne pas les bonnes positions
   au final ! *)
