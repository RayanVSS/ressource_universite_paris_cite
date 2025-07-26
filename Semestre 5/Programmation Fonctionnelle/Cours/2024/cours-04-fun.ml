(* OCaml et les fonctions *)

(* En OCaml, les fonctions sont des valeurs comme les autres,
   on peut par exemple créer des paires de fonctions, ou des listes
   de fonctions, etc (possibilité peu utilisée en pratique).
   Attention à bien parenthéser suffisemment. *)

let pairfun = ((fun x -> x), (fun x -> x+1))
let listfun = [(fun x -> x); (fun x -> x+1)]
let _ = snd pairfun 42
let _ = List.hd listfun 42


(* Nettement plus intéressant : des fonctions en arguments.
   Une fonction d'ordre supérieur est une fonction prenant une fonction
   en argument. On parle aussi de "fonctionnelles".

   Exemple: List.init, List.map, List.filter, ... *)

let cent = List.init 100 (fun n -> n)

let vrac = List.init 100 (fun n -> (n*n + 13) mod 47)

let vrac' = List.map (fun n -> (n*n + 13) mod 47) cent

let vrac2 =
  List.map (fun n -> n mod 47)
   (List.map (fun n -> n + 13)
     (List.map (fun n -> n*n) cent))

(* Autre écriture possible, en utilisant |> *)

let vrac2' = cent |> List.map (fun n -> n*n)
                  |> List.map (fun n -> n + 13)
                  |> List.map (fun n -> n mod 47)

(* NB: x |> f  c'est  f x  (c'est même la définition de cet opérateur)
       x |> f |> g  c'est (g (f x)) *)

(* Au fait, répéter ainsi des List.map n'est pas recommandé,
   cela crée trois listes dont deux intermédiaires superflues.
   C'était juste pour montrer qu'on peut le faire *)


(* Comment est défini ce List.map ? Cf TP 2 *)

let rec map f l = match l with
  | [] -> []
  | x :: l' -> f x :: map f l'

(* Comment définir ce List.init ? *)

let rec init_gen a b f =
  if a=b then []
  else f a :: init_gen (a+1) b f

let init n f = init_gen 0 n f

(* ou bien encore : *)

let rec init_acc n f l =
  if n = 0 then l
  else init_acc (n-1) f (f (n-1) :: l)

let init n f = init_acc n f []

(* Remarque : on peut obtenir une fonction "range" facilement
   avec List.init *)

let range a b = List.init (b-a+1) (fun n -> n+a)

let _ = range 5 10

(* Autre fonctionnelle classique : List.filter, cf TP 2 *)

let _ = List.filter (fun x -> x < 20) vrac
let _ = List.filter (fun x -> x mod 2 = 0) vrac

(* Une définition possible de List.filter *)

let rec filter f l = match l with
  | [] -> []
  | x :: l' -> if f x then x :: filter f l' else filter f l'


(* Note : on peut parfois raccourcir l'écriture de certaines fonctions
   anonymes grace aux opérateurs en forme "préfixe" *)

let _ = map (fun x -> 10+x) [1;2;3]
let _ = map ((+) 10) [1;2;3]

let _ = 10 + 20
let _ = (+) 10 20
let _ = (+)
let _ = (+) 10
let _ = fun x -> (+) 10 x

(* attention avec la multiplication prefixe, mettre des blancs sinon
   ce sont des commentaires ! *)

let _ = ( * )

let _ = filter ((>) 20) vrac
(* Donne les "petits" dans la liste vrac
   car (>) 20
       = fun x -> (>) 20 x
       = fun x -> 20 > x
       = fun x -> x < 20
*)


(* Retour sur la fonction de tri presentée au premier cours *)

let rec sort = function
| [] -> []
| x :: xs ->
   sort (List.filter ((<) x) xs)
   @ [x]
   @ sort (List.filter ((>=) x) xs)


let _ = sort vrac (* c'est un tri décroissant ! *)

let rec sort_crois = function
| [] -> []
| x :: xs ->
   sort_crois (List.filter ((>) x) xs)
   @ [x]
   @ sort_crois (List.filter ((<=) x) xs)


(* Mieux, un tri recevant une fonction de comparaison en argument *)

let rec sort_gen cmp = function
| [] -> []
| x :: xs ->
   sort_gen cmp (List.filter (fun y -> not (cmp x y)) xs)
   @ [x]
   @ sort_gen cmp (List.filter (fun y -> cmp x y) xs)

let _ = sort_gen (<=) vrac
let _ = sort_gen (<) vrac (* Ici ça ne change rien au résultat *)
let _ = sort_gen (>=) vrac
let sort l = sort_gen (>=) l (* On retrouve la fonction "sort" de départ *)

(* Un très grand classique des fonctions OCaml : la composition de fonctions.
   Ceci correspond au "f°g" des mathématiques. Bien prendre le temps de
   comprendre le type que OCaml donne à cette fonction compose. *)

let compose f g x = f (g x)
(* ou de façon équivalente: *)
let compose f g = fun x -> f (g x)

(* Quelques raccourcis possibles dans sort_gen :

   (cmp x) au lieu de (fun y -> cmp x y)

   (compose not (cmp x)) au lieu de (fun y -> not (cmp x y))
*)

(* Mieux encore : utiliser List.partition équivaut à deux List.filter *)

let rec sort_gen cmp = function
| [] -> []
| x :: xs ->
   let high,low = List.partition (cmp x) xs in
   sort_gen cmp low @ [x] @ sort_gen cmp high

let _ = sort_gen (<) vrac


(* La librairie standard OCaml fournit List.sort (implémentant un tri fusion).
   Mais attention, la comparaison que List.sort attend est à
   résultat entier et non booléen.
   Convention : 0 pour égal, positif si le premier argument est le plus grand,
   négatif sinon.
   On peut utiliser la fonction standard "compare" pour cela *)

let _ = List.sort
let _ = compare
let _ = compare 1 2
let _ = List.sort compare vrac
let _ = List.sort (fun x y -> - (compare x y)) vrac

(* Remarque : tant que l'on utilise des entiers "pas trop gros",
   une simple soustraction peut servir de comparaison. Mais attention
   aux "overflows" *)

let _ = List.sort (-) vrac
